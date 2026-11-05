import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/providers/core_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class CodeRoomApp extends ConsumerWidget {
  const CodeRoomApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    ref.read(notificationServiceProvider).onRoomSelected = (code) =>
        router.go(AppRoutes.chat(code));

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, _) => MaterialApp.router(
        title: 'Code Room',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: router,
        builder: (context, child) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value:
                (isDark
                        ? SystemUiOverlayStyle.light
                        : SystemUiOverlayStyle.dark)
                    .copyWith(
                      statusBarColor: Colors.transparent,
                      systemNavigationBarColor: Colors.transparent,
                      systemNavigationBarContrastEnforced: false,
                      systemNavigationBarIconBrightness: isDark
                          ? Brightness.light
                          : Brightness.dark,
                    ),
            child: child!,
          );
        },
      ),
    );
  }
}
