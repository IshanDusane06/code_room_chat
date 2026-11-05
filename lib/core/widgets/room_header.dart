import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_icons.dart';

class RoomHeader extends StatelessWidget {
  const RoomHeader({
    required this.roomCode,
    required this.memberCount,
    required this.onBack,
    super.key,
  });

  final String roomCode;
  final int memberCount;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = 39.06.w;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.6.w),
      child: Row(
        children: [
          Material(
            color: colors.circle,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onBack,
              child: SizedBox.square(
                dimension: size,
                child: AppIcon.back(size: 24.w, color: colors.textPrimary),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Room #$roomCode',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.roomTitle.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  memberCount == 1 ? '1 member' : '$memberCount members',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.roomSubtitle.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: size),
        ],
      ),
    );
  }
}
