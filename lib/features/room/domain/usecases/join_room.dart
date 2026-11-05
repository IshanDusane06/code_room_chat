import '../entities/room_identity.dart';
import '../repositories/room_repository.dart';

class JoinRoom {
  const JoinRoom(this._repository);

  final RoomRepository _repository;

  Future<RoomIdentity> call(String code) => _repository.joinRoom(code);
}
