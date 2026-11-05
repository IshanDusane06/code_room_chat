import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/services/room_code_generator.dart';

class CodeInput extends StatelessWidget {
  const CodeInput({
    required this.controller,
    required this.onCompleted,
    required this.enabled,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onCompleted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 279.8.w,
      height: 64.w,
      decoration: BoxDecoration(
        color: colors.codeField,
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 42.5.w,
            bottom: 16.w,
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) => Row(
                children: [
                  for (var i = 0; i < RoomCodeGenerator.codeLength; i++)
                    Padding(
                      padding: EdgeInsets.only(
                        right: i == RoomCodeGenerator.codeLength - 1
                            ? 0
                            : 18.9.w,
                      ),
                      child: _CodeSlot(
                        digit: i < value.text.length ? value.text[i] : null,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: controller,
                enabled: enabled,
                keyboardType: TextInputType.number,
                showCursor: false,
                enableInteractiveSelection: false,
                maxLength: RoomCodeGenerator.codeLength,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                ),
                onChanged: (value) {
                  if (value.length == RoomCodeGenerator.codeLength) {
                    onCompleted(value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeSlot extends StatelessWidget {
  const _CodeSlot({required this.digit});

  final String? digit;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: 18.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 140),
            child: Text(
              digit ?? '',
              key: ValueKey(digit),
              style: AppTextStyles.codeDigit.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: 2.w),
          Container(height: 3.5.w, color: colors.codeDash),
        ],
      ),
    );
  }
}
