import '../repositories/chat_repository.dart';

class LoadOlderMessages {
  const LoadOlderMessages(this._repository);

  final ChatRepository _repository;

  Future<bool> call(String roomCode, int visibleCount) =>
      _repository.loadOlder(roomCode, visibleCount);
}
