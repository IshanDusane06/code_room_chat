import 'package:drift/drift.dart';

@DataClassName('RoomRow')
class Rooms extends Table {
  TextColumn get code => text()();
  IntColumn get memberCount => integer().withDefault(const Constant(1))();
  IntColumn get createdAtMicros => integer().nullable()();
  BoolColumn get hasMoreHistory =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {code};
}

@DataClassName('RoomIdentityRow')
class RoomIdentities extends Table {
  TextColumn get roomCode => text()();
  TextColumn get uid => text()();
  TextColumn get displayName => text()();
  BoolColumn get acknowledged => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {roomCode};
}

@DataClassName('MessageRow')
@TableIndex(name: 'messages_room_sort', columns: {#roomCode, #sortAtMicros})
class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get roomCode => text()();
  TextColumn get senderId => text()();
  TextColumn get senderName => text()();
  TextColumn get body => text()();
  IntColumn get createdAtMicros => integer().nullable()();
  IntColumn get sortAtMicros => integer()();
  IntColumn get status => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
