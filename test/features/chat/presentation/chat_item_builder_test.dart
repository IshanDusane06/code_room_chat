import 'package:code_room_chat_app/features/chat/domain/entities/message.dart';
import 'package:code_room_chat_app/features/chat/presentation/utils/chat_item_builder.dart';
import 'package:flutter_test/flutter_test.dart';

Message message(String id, DateTime at) => Message(
  id: id,
  roomCode: 'room',
  senderId: 'a',
  senderName: 'Brave Badger',
  text: id,
  createdAt: at,
  sortAt: at,
  status: MessageStatus.sent,
);

void main() {
  final now = DateTime(2026, 11, 4, 12);

  test('empty history has no items', () {
    expect(buildChatItems([], now), isEmpty);
  });

  test('one separator per day, placed above that day in a reversed list', () {
    final items = buildChatItems([
      message('c', DateTime(2026, 11, 4, 9)),
      message('b', DateTime(2026, 11, 4, 8)),
      message('a', DateTime(2026, 11, 3, 23)),
    ], now);

    expect(items, hasLength(5));
    expect((items[2] as DateSeparatorItem).label, 'Today');
    expect((items[4] as DateSeparatorItem).label, 'Yesterday');
  });

  test('labels older dates and handles month boundaries', () {
    expect(dateLabel(DateTime(2026, 10, 1), now), '1 Oct 2026');
    expect(
      dateLabel(DateTime(2026, 10, 31, 23), DateTime(2026, 11, 1, 1)),
      'Yesterday',
    );
  });

  test('formats time as 24 hour', () {
    expect(timeLabel(DateTime(2026, 11, 4, 12)), '12:00');
  });
}
