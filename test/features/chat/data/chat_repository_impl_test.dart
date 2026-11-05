import 'package:code_room_chat_app/core/database/app_database.dart';
import 'package:code_room_chat_app/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:code_room_chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:code_room_chat_app/features/chat/domain/entities/message.dart';
import 'package:code_room_chat_app/features/room/data/datasources/room_local_data_source.dart';
import 'package:code_room_chat_app/features/room/data/models/room_model.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

void main() {
  late AppDatabase database;
  late FakeChatRemote remote;
  late FakeConnectivity connectivity;
  late ChatLocalDataSource local;
  late ChatRepositoryImpl repository;

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 30));

  Future<List<Message>> visible([int limit = 500]) =>
      repository.watchMessages('room', limit).first;

  Future<void> send(String text) => repository.sendMessage(
    roomCode: 'room',
    senderId: 'me',
    senderName: 'Calm Otter',
    text: text,
  );

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    remote = FakeChatRemote();
    connectivity = FakeConnectivity();
    local = ChatLocalDataSource(database);
    repository = ChatRepositoryImpl(
      remote: remote,
      local: local,
      connectivity: connectivity,
      retryDelay: const Duration(milliseconds: 5),
    );
    await RoomLocalDataSource(
      database,
    ).saveRoom(const RoomModel(code: 'room', memberCount: 1));
  });

  tearDown(() => database.close());

  group('sync', () {
    test('seeds only the newest page on first open', () async {
      for (var i = 0; i < 45; i++) {
        remote.add('m$i');
      }
      final subscription = repository.syncMessages('room').listen((_) {});
      await settle();

      final messages = await visible();
      expect(messages, hasLength(ChatRepositoryImpl.pageSize));
      expect(messages.first.id, 'm44');
      expect(messages.last.id, 'm15');
      await subscription.cancel();
    });

    test('resumes listening from the newest stored timestamp', () async {
      final seeded = remote.add('m0');
      final subscription = repository.syncMessages('room').listen((_) {});
      await settle();

      expect(remote.watchedFrom.last, seeded.createdAtMicros);
      await subscription.cancel();
    });

    test('reports only unseen messages and never duplicates', () async {
      final first = remote.add('m0');
      final batches = <List<Message>>[];
      final subscription = repository.syncMessages('room').listen(batches.add);
      await settle();

      final second = remote.add('m1');
      remote.emit([first, second]);
      await settle();

      expect(batches.single.map((m) => m.id), ['m1']);
      expect(await visible(), hasLength(2));
      await subscription.cancel();
    });

    test('restarts from newest timestamp after reconnecting', () async {
      remote.add('m0');
      final subscription = repository.syncMessages('room').listen((_) {});
      await settle();

      connectivity.set(false);
      await settle();
      final missed = remote.add('m1');
      remote.emit([missed]);
      connectivity.set(true);
      await settle();

      expect(remote.watchedFrom, hasLength(2));
      remote.emit([missed]);
      await settle();
      expect((await visible()).first.id, 'm1');
      await subscription.cancel();
    });
  });

  group('pagination', () {
    test('fetches older pages without gaps or duplicates', () async {
      for (var i = 0; i < 70; i++) {
        remote.add('m$i');
      }
      final subscription = repository.syncMessages('room').listen((_) {});
      await settle();

      expect(await repository.loadOlder('room', 30), isTrue);
      expect(await visible(), hasLength(60));
      expect(await repository.loadOlder('room', 60), isTrue);

      final all = await visible();
      expect(all, hasLength(70));
      expect(all.map((m) => m.id).toSet(), hasLength(70));
      expect(await local.hasMoreHistory('room'), isFalse);
      expect(await repository.loadOlder('room', 70), isFalse);
      await subscription.cancel();
    });

    test('reveals stored rows while offline', () async {
      for (var i = 0; i < 60; i++) {
        remote.add('m$i');
      }
      final subscription = repository.syncMessages('room').listen((_) {});
      await settle();
      await repository.loadOlder('room', 30);
      connectivity.set(false);

      expect(await repository.loadOlder('room', 30), isTrue);
      expect(await repository.loadOlder('room', 60), isFalse);
      await subscription.cancel();
    });
  });

  group('offline persistence', () {
    test('history survives with no connectivity on rejoin', () async {
      remote.add('m0');
      remote.add('m1');
      final subscription = repository.syncMessages('room').listen((_) {});
      await settle();
      await subscription.cancel();

      connectivity.online = false;
      remote.docs.clear();
      final rejoined = ChatRepositoryImpl(
        remote: remote,
        local: local,
        connectivity: connectivity,
      );

      final messages = await rejoined.watchMessages('room', 30).first;
      expect(messages.map((m) => m.id), ['m1', 'm0']);
    });
  });

  group('outbox', () {
    test('offline message is stored as pending and not sent', () async {
      connectivity.online = false;
      await send('hello');

      final messages = await visible();
      expect(messages.single.isPending, isTrue);
      expect(messages.single.createdAt, isNull);
      expect(remote.sendCalls, 0);
    });

    test('pending message sorts after newest server message', () async {
      remote.add('future', at: DateTime(2100).microsecondsSinceEpoch);
      final subscription = repository.syncMessages('room').listen((_) {});
      await settle();

      connectivity.online = false;
      await send('hello');

      expect((await visible()).first.text, 'hello');
      await subscription.cancel();
    });

    test('delivers pending messages in order on reconnect', () async {
      connectivity.online = false;
      await send('first');
      await send('second');
      final subscription = repository.syncMessages('room').listen((_) {});
      await settle();

      connectivity.set(true);
      await settle();

      expect(remote.docs.map((doc) => doc.text), ['first', 'second']);
      await subscription.cancel();
    });

    test('server echo replaces pending with the server timestamp', () async {
      await send('hello');
      final sent = remote.docs.single;
      await local.upsertRemote([sent]);

      final message = (await visible()).single;
      expect(message.isPending, isFalse);
      expect(message.createdAt?.microsecondsSinceEpoch, sent.createdAtMicros);
    });

    test('a failed message blocks newer ones and retries in order', () async {
      connectivity.online = false;
      await send('first');
      await send('second');
      final subscription = repository.syncMessages('room').listen((_) {});
      await settle();

      remote.failNextSends = 3;
      connectivity.set(true);
      await settle();

      expect(remote.docs.map((doc) => doc.text), ['first', 'second']);
      await subscription.cancel();
    });

    test('a failed server check does not strand the message', () async {
      await send('hello');
      await local.pendingMessages('room');
      remote.docs.clear();
      remote.failNextFetches = 2;

      final subscription = repository.syncMessages('room').listen((_) {});
      await settle();

      expect(remote.docs.single.text, 'hello');
      await subscription.cancel();
    });

    test('a message sent during a failing retry keeps its place', () async {
      connectivity.online = false;
      await send('first');
      remote.failNextSends = 2;
      final subscription = repository.syncMessages('room').listen((_) {});
      connectivity.set(true);
      await send('second');
      await settle();

      expect(remote.docs.map((doc) => doc.text), ['first', 'second']);
      await subscription.cancel();
    });

    test('failed send stays pending', () async {
      remote.failSends = true;
      await send('hello');

      expect((await visible()).single.isPending, isTrue);
    });

    test('retry does not resend a message the server already has', () async {
      await send('hello');
      expect(remote.sendCalls, 1);

      final subscription = repository.syncMessages('room').listen((_) {});
      await settle();

      expect(remote.sendCalls, 1);
      expect((await visible()).single.isPending, isFalse);
      await subscription.cancel();
    });
  });
}
