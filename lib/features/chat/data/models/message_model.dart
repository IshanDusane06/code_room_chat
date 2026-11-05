class MessageModel {
  const MessageModel({
    required this.id,
    required this.roomCode,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.createdAtMicros,
  });

  final String id;
  final String roomCode;
  final String senderId;
  final String senderName;
  final String text;
  final int createdAtMicros;
}
