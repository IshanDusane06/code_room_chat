import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_icons.dart';

class MessageComposer extends StatefulWidget {
  const MessageComposer({required this.onSend, super.key});

  final ValueChanged<String> onSend;

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final _controller = TextEditingController();
  final _pressed = ValueNotifier(false);

  @override
  void dispose() {
    _controller.dispose();
    _pressed.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.only(left: 15.1.w, right: 14.4.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: BoxConstraints(minHeight: 42.1.w),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 15.1.w),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(21.w),
              ),
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                maxLength: 2000,
                textCapitalization: TextCapitalization.sentences,
                style: AppTextStyles.inputText.copyWith(
                  color: colors.textPrimary,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  counterText: '',
                  hintText: 'Type a message',
                  hintStyle: AppTextStyles.inputText.copyWith(
                    color: colors.hint,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.w),
                ),
              ),
            ),
          ),
          SizedBox(width: 7.w),
          GestureDetector(
            onTapDown: (_) => _pressed.value = true,
            onTapUp: (_) => _pressed.value = false,
            onTapCancel: () => _pressed.value = false,
            onTap: _send,
            child: ValueListenableBuilder<bool>(
              valueListenable: _pressed,
              builder: (context, pressed, child) => AnimatedScale(
                scale: pressed ? 0.88 : 1,
                duration: const Duration(milliseconds: 110),
                child: child,
              ),
              child: Container(
                width: 41.5.w,
                height: 41.5.w,
                decoration: BoxDecoration(
                  color: colors.accent,
                  shape: BoxShape.circle,
                ),
                child: AppIcon.send(size: 19.w, color: colors.onAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
