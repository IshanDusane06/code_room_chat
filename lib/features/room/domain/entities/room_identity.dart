class RoomIdentity {
  const RoomIdentity({
    required this.roomCode,
    required this.uid,
    required this.displayName,
    required this.acknowledged,
  });

  final String roomCode;
  final String uid;
  final String displayName;
  final bool acknowledged;
}
