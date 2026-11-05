import '../repositories/room_repository.dart';

class SyncRoom {
  const SyncRoom(this._repository);

  final RoomRepository _repository;

  Stream<void> call(String code) => _repository.syncRoom(code);
}
