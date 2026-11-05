import 'dart:async';

import 'package:code_room_chat_app/core/network/connectivity_service.dart';
import 'package:code_room_chat_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:code_room_chat_app/features/chat/data/models/message_model.dart';
import 'package:code_room_chat_app/features/chat/domain/entities/message.dart';

class FakeConnectivity implements ConnectivityService {
  FakeConnectivity({this.online = true});

  bool online;
  final _changes = StreamController<bool>.broadcast();

  void set(bool value) {
    online = value;
    _changes.add(value);
  }

  @override
  Future<bool> get isOnline async => online;

  @override
  Stream<bool> get onlineChanges => _changes.stream;
}

class FakeChatRemote implements ChatRemoteDataSource {
  final List<MessageModel> docs = [];
  final List<int?> watchedFrom = [];
  final _live = StreamController<List<MessageModel>>.broadcast();
  int clock = 1000;
  int sendCalls = 0;
  bool failSends = false;
  int failNextSends = 0;
  int failNextFetches = 0;

  MessageModel add(String id, {String sender = 'other', int? at}) {
    final model = MessageModel(
      id: id,
      roomCode: 'room',
      senderId: sender,
      senderName: 'Brave Badger',
      text: id,
      createdAtMicros: at ?? clock++,
    );
    docs.add(model);
    return model;
  }

  void emit(List<MessageModel> models) => _live.add(models);

  List<MessageModel> get _newestFirst =>
      [...docs]..sort((a, b) => b.createdAtMicros.compareTo(a.createdAtMicros));

  @override
  Future<List<MessageModel>> fetchLatest(String roomCode, int limit) async =>
      _newestFirst.take(limit).toList();

  @override
  Future<List<MessageModel>> fetchUpTo(
    String roomCode,
    int beforeMicros,
    int limit,
  ) async => _newestFirst
      .where((doc) => doc.createdAtMicros <= beforeMicros)
      .take(limit)
      .toList();

  @override
  Future<MessageModel?> fetchMessage(String roomCode, String id) async {
    if (failNextFetches > 0) {
      failNextFetches--;
      throw Exception('unavailable');
    }
    for (final doc in docs) {
      if (doc.id == id) return doc;
    }
    return null;
  }

  @override
  Future<void> send(Message message) async {
    sendCalls++;
    if (failSends) throw Exception('unavailable');
    if (failNextSends > 0) {
      failNextSends--;
      throw Exception('unavailable');
    }
    docs.add(
      MessageModel(
        id: message.id,
        roomCode: message.roomCode,
        senderId: message.senderId,
        senderName: message.senderName,
        text: message.text,
        createdAtMicros: clock++,
      ),
    );
  }

  @override
  Stream<List<MessageModel>> watchFrom(String roomCode, int? fromMicros) {
    watchedFrom.add(fromMicros);
    return _live.stream;
  }
}
