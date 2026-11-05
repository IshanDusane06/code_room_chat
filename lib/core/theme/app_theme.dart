import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get dark => _build(AppColors.dark, Brightness.dark);
  static ThemeData get light => _build(AppColors.light, Brightness.light);

  static ThemeData _build(AppColors colors, Brightness brightness) => ThemeData(
    brightness: brightness,
    scaffoldBackgroundColor: colors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: colors.accent,
      brightness: brightness,
      surface: colors.background,
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: colors.accentText),
    extensions: [colors],
  );
}
