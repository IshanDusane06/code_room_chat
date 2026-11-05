import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/message.dart';
import '../models/message_model.dart';

class ChatLocalDataSource {
  const ChatLocalDataSource(this._database);

  final AppDatabase _database;

  Stream<List<Message>> watchMessages(String roomCode, int limit) {
    final query = _database.select(_database.messages)
      ..where((table) => table.roomCode.equals(roomCode))
      ..orderBy([
        (table) => OrderingTerm.desc(table.sortAtMicros),
        (table) => OrderingTerm.desc(table.id),
      ])
      ..limit(limit);
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }

  Future<int> countMessages(String roomCode) {
    final count = _database.messages.id.count();
    final query = _database.selectOnly(_database.messages)
      ..addColumns([count])
      ..where(_database.messages.roomCode.equals(roomCode));
    return query.map((row) => row.read(count)!).getSingle();
  }

  Future<int?> newestServerMicros(String roomCode) {
    final newest = _database.messages.createdAtMicros.max();
    return _readBound(roomCode, newest);
  }

  Future<int?> oldestServerMicros(String roomCode) {
    final oldest = _database.messages.createdAtMicros.min();
    return _readBound(roomCode, oldest);
  }

  Future<int?> _readBound(String roomCode, Expression<int> bound) {
    final query = _database.selectOnly(_database.messages)
      ..addColumns([bound])
      ..where(_database.messages.roomCode.equals(roomCode));
    return query.map((row) => row.read(bound)).getSingle();
  }

  Future<bool> hasMoreHistory(String roomCode) async {
    final query = _database.select(_database.rooms)
      ..where((table) => table.code.equals(roomCode));
    final room = await query.getSingleOrNull();
    return room?.hasMoreHistory ?? true;
  }

  Future<void> setHasMoreHistory(String roomCode, bool hasMore) =>
      (_database.update(_database.rooms)
            ..where((table) => table.code.equals(roomCode)))
          .write(RoomsCompanion(hasMoreHistory: Value(hasMore)));

  Future<void> insertPending(Message message) => _database
      .into(_database.messages)
      .insert(
        MessagesCompanion.insert(
          id: message.id,
          roomCode: message.roomCode,
          senderId: message.senderId,
          senderName: message.senderName,
          body: message.text,
          sortAtMicros: message.sortAt.microsecondsSinceEpoch,
          status: MessageStatus.pending.index,
        ),
      );

  Future<List<Message>> pendingMessages(String roomCode) async {
    final query = _database.select(_database.messages)
      ..where(
        (table) =>
            table.roomCode.equals(roomCode) &
            table.status.equals(MessageStatus.pending.index),
      )
      ..orderBy([(table) => OrderingTerm.asc(table.sortAtMicros)]);
    final rows = await query.get();
    return rows.map(_toEntity).toList();
  }

  Future<List<MessageModel>> upsertRemote(List<MessageModel> models) =>
      _database.transaction(() async {
        final ids = models.map((model) => model.id).toList();
        final existingQuery = _database.selectOnly(_database.messages)
          ..addColumns([_database.messages.id])
          ..where(_database.messages.id.isIn(ids));
        final existing = await existingQuery
            .map((row) => row.read(_database.messages.id)!)
            .get();
        await _database.batch((batch) {
          batch.insertAllOnConflictUpdate(
            _database.messages,
            models.map(_toCompanion).toList(),
          );
        });
        final known = existing.toSet();
        return models.where((model) => !known.contains(model.id)).toList();
      });

  MessagesCompanion _toCompanion(MessageModel model) =>
      MessagesCompanion.insert(
        id: model.id,
        roomCode: model.roomCode,
        senderId: model.senderId,
        senderName: model.senderName,
        body: model.text,
        createdAtMicros: Value(model.createdAtMicros),
        sortAtMicros: model.createdAtMicros,
        status: MessageStatus.sent.index,
      );

  Message _toEntity(MessageRow row) => Message(
    id: row.id,
    roomCode: row.roomCode,
    senderId: row.senderId,
    senderName: row.senderName,
    text: row.body,
    createdAt: row.createdAtMicros == null
        ? null
        : DateTime.fromMicrosecondsSinceEpoch(row.createdAtMicros!),
    sortAt: DateTime.fromMicrosecondsSinceEpoch(row.sortAtMicros),
    status: MessageStatus.values[row.status],
  );
}
