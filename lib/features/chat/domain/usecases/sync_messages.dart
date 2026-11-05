import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class SyncMessages {
  const SyncMessages(this._repository);

  final ChatRepository _repository;

  Stream<List<Message>> call(String roomCode) =>
      _repository.syncMessages(roomCode);
}
