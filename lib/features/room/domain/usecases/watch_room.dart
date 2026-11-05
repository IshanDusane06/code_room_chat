import '../entities/room.dart';
import '../repositories/room_repository.dart';

class WatchRoom {
  const WatchRoom(this._repository);

  final RoomRepository _repository;

  Stream<Room?> call(String code) => _repository.watchRoom(code);
}
