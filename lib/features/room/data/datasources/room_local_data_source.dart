import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/room_identity.dart';
import '../models/room_model.dart';

class RoomLocalDataSource {
  const RoomLocalDataSource(this._database);

  final AppDatabase _database;

  Future<RoomIdentity?> getIdentity(String code) async {
    final query = _database.select(_database.roomIdentities)
      ..where((table) => table.roomCode.equals(code));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toIdentity(row);
  }

  Stream<RoomIdentity?> watchIdentity(String code) {
    final query = _database.select(_database.roomIdentities)
      ..where((table) => table.roomCode.equals(code));
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : _toIdentity(row),
    );
  }

  Stream<Room?> watchRoom(String code) {
    final query = _database.select(_database.rooms)
      ..where((table) => table.code.equals(code));
    return query.watchSingleOrNull().map(
      (row) => row == null
          ? null
          : Room(code: row.code, memberCount: row.memberCount),
    );
  }

  Future<void> saveMembership(RoomModel room, RoomIdentity identity) =>
      _database.transaction(() async {
        await saveRoom(room);
        await _database
            .into(_database.roomIdentities)
            .insertOnConflictUpdate(
              RoomIdentitiesCompanion.insert(
                roomCode: identity.roomCode,
                uid: identity.uid,
                displayName: identity.displayName,
                acknowledged: Value(identity.acknowledged),
              ),
            );
      });

  Future<void> saveRoom(RoomModel room) => _database
      .into(_database.rooms)
      .insert(
        RoomsCompanion.insert(
          code: room.code,
          memberCount: Value(room.memberCount),
          createdAtMicros: Value(room.createdAtMicros),
        ),
        onConflict: DoUpdate(
          (_) => RoomsCompanion(
            memberCount: Value(room.memberCount),
            createdAtMicros: Value(room.createdAtMicros),
          ),
        ),
      );

  Future<void> acknowledge(String code) =>
      (_database.update(_database.roomIdentities)
            ..where((table) => table.roomCode.equals(code)))
          .write(const RoomIdentitiesCompanion(acknowledged: Value(true)));

  RoomIdentity _toIdentity(RoomIdentityRow row) => RoomIdentity(
    roomCode: row.roomCode,
    uid: row.uid,
    displayName: row.displayName,
    acknowledged: row.acknowledged,
  );
}
