import '../repositories/chat_repository.dart';

class SendMessage {
  const SendMessage(this._repository);

  final ChatRepository _repository;

  Future<void> call({
    required String roomCode,
    required String senderId,
    required String senderName,
    required String text,
  }) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return Future.value();
    return _repository.sendMessage(
      roomCode: roomCode,
      senderId: senderId,
      senderName: senderName,
      text: trimmed,
    );
  }
}
