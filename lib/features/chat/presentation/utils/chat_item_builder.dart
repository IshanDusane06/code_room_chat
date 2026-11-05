import 'package:intl/intl.dart';

import '../../domain/entities/message.dart';

sealed class ChatItem {
  const ChatItem();
}

final class MessageItem extends ChatItem {
  const MessageItem(this.message);

  final Message message;
}

final class DateSeparatorItem extends ChatItem {
  const DateSeparatorItem(this.label);

  final String label;
}

List<ChatItem> buildChatItems(List<Message> newestFirst, DateTime now) {
  final items = <ChatItem>[];
  for (var index = 0; index < newestFirst.length; index++) {
    final message = newestFirst[index];
    items.add(MessageItem(message));
    final isLast = index == newestFirst.length - 1;
    if (isLast || !_sameDay(message.sortAt, newestFirst[index + 1].sortAt)) {
      items.add(DateSeparatorItem(dateLabel(message.sortAt, now)));
    }
  }
  return items;
}

String dateLabel(DateTime date, DateTime now) {
  final local = date.toLocal();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(local.year, local.month, local.day);
  final difference = DateTime(
    today.year,
    today.month,
    today.day,
    12,
  ).difference(DateTime(day.year, day.month, day.day, 12)).inHours;
  if (difference == 0) return 'Today';
  if (difference == 24) return 'Yesterday';
  return DateFormat('d MMM yyyy').format(local);
}

String timeLabel(DateTime date) => DateFormat('HH:mm').format(date.toLocal());

bool _sameDay(DateTime a, DateTime b) {
  final first = a.toLocal();
  final second = b.toLocal();
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}
