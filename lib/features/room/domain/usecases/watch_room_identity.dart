import '../entities/room_identity.dart';
import '../repositories/room_repository.dart';

class WatchRoomIdentity {
  const WatchRoomIdentity(this._repository);

  final RoomRepository _repository;

  Stream<RoomIdentity?> call(String code) => _repository.watchIdentity(code);
}
