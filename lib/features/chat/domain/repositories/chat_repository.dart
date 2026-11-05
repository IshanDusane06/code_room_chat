import '../entities/message.dart';

abstract interface class ChatRepository {
  Stream<List<Message>> watchMessages(String roomCode, int limit);
  Future<bool> loadOlder(String roomCode, int visibleCount);
  Future<void> sendMessage({
    required String roomCode,
    required String senderId,
    required String senderName,
    required String text,
  });
  Stream<List<Message>> syncMessages(String roomCode);
}
