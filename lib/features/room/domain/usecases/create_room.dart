import '../entities/room_identity.dart';
import '../repositories/room_repository.dart';

class CreateRoom {
  const CreateRoom(this._repository);

  final RoomRepository _repository;

  Future<RoomIdentity> call() => _repository.createRoom();
}
