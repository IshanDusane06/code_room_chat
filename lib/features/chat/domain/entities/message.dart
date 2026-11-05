enum MessageStatus { pending, sent }

class Message {
  const Message({
    required this.id,
    required this.roomCode,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.createdAt,
    required this.sortAt,
    required this.status,
  });

  final String id;
  final String roomCode;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime? createdAt;
  final DateTime sortAt;
  final MessageStatus status;

  bool get isPending => status == MessageStatus.pending;
}
