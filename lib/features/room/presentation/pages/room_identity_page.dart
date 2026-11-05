import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/room_header.dart';
import '../providers/room_providers.dart';

class RoomIdentityPage extends ConsumerWidget {
  const RoomIdentityPage({required this.roomCode, super.key});

  final String roomCode;

  Future<void> _continue(BuildContext context, WidgetRef ref) async {
    await ref.read(acknowledgeIdentityProvider)(roomCode);
    if (context.mounted) context.pushReplacement(AppRoutes.chat(roomCode));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(roomSyncProvider(roomCode));
    final room = ref.watch(roomProvider(roomCode)).value;
    final identity = ref.watch(roomIdentityProvider(roomCode)).value;
    final colors = context.colors;
    final systemInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 81.4.h),
          RoomHeader(
            roomCode: roomCode,
            memberCount: room?.memberCount ?? 1,
            onBack: context.pop,
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.6.w),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.w,
                    vertical: 32.3.w,
                  ),
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(19.5.w),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'For this room, you are',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.identityLabel.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 7.8.w),
                      _IdentityName(name: identity?.displayName ?? ''),
                      SizedBox(height: 3.6.w),
                      Text(
                        'This is your anonymous identifier, visible only to others in this room.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.identityHint.copyWith(
                          color: colors.textSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 31.w),
                PrimaryButton(
                  label: 'Acknowledge and continue',
                  onPressed: () => _continue(context, ref),
                ),
              ],
            ),
          ),
          SizedBox(height: max(54.h, systemInset + 16.w)),
        ],
      ),
    );
  }
}

class _IdentityName extends StatelessWidget {
  const _IdentityName({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: context.colors.nameGradient,
    );
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutBack,
      builder: (context, value, child) => Opacity(
        opacity: value.clamp(0, 1),
        child: Transform.scale(scale: 0.85 + 0.15 * value, child: child),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: gradient.createShader,
          child: Padding(
            padding: EdgeInsets.only(bottom: 12.w),
            child: Text(
              name.replaceFirst(' ', '\n'),
              textAlign: TextAlign.center,
              style: AppTextStyles.identityName.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
