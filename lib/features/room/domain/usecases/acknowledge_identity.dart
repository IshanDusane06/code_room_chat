import '../repositories/room_repository.dart';

class AcknowledgeIdentity {
  const AcknowledgeIdentity(this._repository);

  final RoomRepository _repository;

  Future<void> call(String code) => _repository.acknowledgeIdentity(code);
}
