import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class DateSeparator extends StatelessWidget {
  const DateSeparator({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.only(left: 10.4.w, bottom: 23.w),
      child: Center(
        child: Container(
          height: 23.9.w,
          padding: EdgeInsets.symmetric(horizontal: 11.3.w),
          decoration: BoxDecoration(
            color: colors.circle,
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: Center(
            widthFactor: 1,
            child: Text(
              label,
              style: AppTextStyles.dateLabel.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
