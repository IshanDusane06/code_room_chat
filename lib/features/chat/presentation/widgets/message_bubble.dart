import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/message.dart';
import '../utils/chat_item_builder.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    required this.isMine,
    required this.animate,
    super.key,
  });

  final Message message;
  final bool isMine;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final content = Padding(
      padding: EdgeInsets.only(bottom: 15.w),
      child: Column(
        crossAxisAlignment: isMine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            isMine ? 'You' : '@${message.senderName.replaceAll(' ', '')}',
            style: AppTextStyles.senderName.copyWith(color: colors.textPrimary),
          ),
          SizedBox(height: 3.4.w),
          Container(
            width: 302.29.w,
            padding: EdgeInsets.all(11.33.w),
            decoration: BoxDecoration(
              color: isMine ? colors.accent : colors.card,
              borderRadius: BorderRadius.circular(15.11.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: AppTextStyles.messageBody.copyWith(
                    color: isMine ? colors.onAccentBody : colors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.6.w),
                Align(
                  alignment: Alignment.centerRight,
                  child: _MessageMeta(message: message, isMine: isMine),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (!animate) return content;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 18.w),
          child: child,
        ),
      ),
      child: content,
    );
  }
}

class _MessageMeta extends StatelessWidget {
  const _MessageMeta({required this.message, required this.isMine});

  final Message message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = isMine ? colors.onAccentMuted : colors.textSecondary;
    final createdAt = message.createdAt;
    if (message.isPending || createdAt == null) {
      return Icon(Icons.schedule_rounded, size: 13.w, color: color);
    }
    return Text(
      timeLabel(createdAt),
      style: AppTextStyles.messageTime.copyWith(color: color),
    );
  }
}
