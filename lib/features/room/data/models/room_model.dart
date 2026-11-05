class RoomModel {
  const RoomModel({
    required this.code,
    required this.memberCount,
    this.createdAtMicros,
  });

  final String code;
  final int memberCount;
  final int? createdAtMicros;
}
