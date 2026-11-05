import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  final _pressed = ValueNotifier(false);

  @override
  void dispose() {
    _pressed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTapDown: (_) => _pressed.value = true,
      onTapUp: (_) => _pressed.value = false,
      onTapCancel: () => _pressed.value = false,
      onTap: widget.onPressed,
      child: ValueListenableBuilder<bool>(
        valueListenable: _pressed,
        builder: (context, pressed, child) => AnimatedScale(
          scale: pressed ? 0.97 : 1,
          duration: const Duration(milliseconds: 120),
          child: child,
        ),
        child: Container(
          height: 59.5.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.accent,
            borderRadius: BorderRadius.circular(19.5.w),
            boxShadow: [
              BoxShadow(
                color: colors.accent.withValues(alpha: 0.3),
                blurRadius: 15.w,
                offset: Offset(0, 4.w),
              ),
            ],
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: AppTextStyles.primaryButton.copyWith(color: colors.onAccent),
          ),
        ),
      ),
    );
  }
}
