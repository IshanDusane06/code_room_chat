import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../settings/presentation/widgets/theme_toggle_button.dart';
import '../providers/join_room_controller.dart';
import '../widgets/code_input.dart';

class JoinRoomPage extends ConsumerStatefulWidget {
  const JoinRoomPage({super.key});

  @override
  ConsumerState<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends ConsumerState<JoinRoomPage>
    with SingleTickerProviderStateMixin {
  final _codeController = TextEditingController();
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  @override
  void dispose() {
    _codeController.dispose();
    _shake.dispose();
    super.dispose();
  }

  void _onStateChanged(JoinRoomState? _, JoinRoomState next) {
    switch (next) {
      case JoinRoomFailed():
        _codeController.clear();
        _shake.forward(from: 0);
      case JoinRoomSucceeded(:final identity):
        _codeController.clear();
        FocusManager.instance.primaryFocus?.unfocus();
        ref.read(joinRoomControllerProvider.notifier).reset();
        context.push(
          identity.acknowledged
              ? AppRoutes.chat(identity.roomCode)
              : AppRoutes.identity(identity.roomCode),
        );
      case JoinRoomIdle() || JoinRoomLoading():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(joinRoomControllerProvider, _onStateChanged);
    final state = ref.watch(joinRoomControllerProvider);
    final controller = ref.read(joinRoomControllerProvider.notifier);
    final colors = context.colors;
    final isLoading = state is JoinRoomLoading;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(
              top: 85.5.h,
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      color: colors.codeField,
                      shape: BoxShape.circle,
                    ),
                    child: AppIcon.key(
                      size: Size(34.w, 17.w),
                      color: colors.accentText,
                    ),
                  ),
                  SizedBox(height: 174.h),
                  Text(
                    'Join A Room',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.joinTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 6.5.w),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 44.w),
                    child: Text(
                      'Enter the code to join the anon chat room',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.joinSubtitle.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.5.w),
                  AnimatedBuilder(
                    animation: _shake,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(
                        sin(_shake.value * pi * 6) * 8.w * (1 - _shake.value),
                        0,
                      ),
                      child: child,
                    ),
                    child: CodeInput(
                      controller: _codeController,
                      enabled: !isLoading,
                      onCompleted: controller.join,
                    ),
                  ),
                  SizedBox(height: 10.w),
                  SizedBox(
                    height: 24.w,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: switch (state) {
                        JoinRoomLoading() => SizedBox.square(
                          key: const ValueKey('loading'),
                          dimension: 18.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.accentText,
                          ),
                        ),
                        JoinRoomFailed(:final message) => Text(
                          message,
                          key: ValueKey(message),
                          style: AppTextStyles.joinHelper.copyWith(
                            color: colors.error,
                          ),
                        ),
                        _ => const SizedBox.shrink(),
                      },
                    ),
                  ),
                  SizedBox(height: 6.w),
                  TextButton(
                    onPressed: isLoading ? null : controller.create,
                    child: Text(
                      'Create a new room',
                      style: AppTextStyles.joinAction.copyWith(
                        color: colors.accentText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.viewPaddingOf(context).top + 12.w,
            right: 20.w,
            child: const ThemeToggleButton(),
          ),
        ],
      ),
    );
  }
}
