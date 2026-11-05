import '../entities/room.dart';
import '../entities/room_identity.dart';

abstract interface class RoomRepository {
  Future<RoomIdentity> createRoom();
  Future<RoomIdentity> joinRoom(String code);
  Future<void> acknowledgeIdentity(String code);
  Stream<Room?> watchRoom(String code);
  Stream<RoomIdentity?> watchIdentity(String code);
  Stream<void> syncRoom(String code);
}
