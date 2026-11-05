import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.codeField,
    required this.codeDash,
    required this.circle,
    required this.card,
    required this.accent,
    required this.onAccent,
    required this.onAccentBody,
    required this.onAccentMuted,
    required this.accentText,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textSoft,
    required this.hint,
    required this.error,
    required this.nameGradient,
  });

  final Color background;
  final Color codeField;
  final Color codeDash;
  final Color circle;
  final Color card;
  final Color accent;
  final Color onAccent;
  final Color onAccentBody;
  final Color onAccentMuted;
  final Color accentText;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textSoft;
  final Color hint;
  final Color error;
  final List<Color> nameGradient;

  static const dark = AppColors(
    background: Color(0xFF09090B),
    codeField: Color(0xFF27272A),
    codeDash: Color(0xFFA1A1AA),
    circle: Color(0xFF1F2937),
    card: Color(0xCC111827),
    accent: Color(0xFFB1E457),
    onAccent: Color(0xFF000000),
    onAccentBody: Color(0xFF1F2937),
    onAccentMuted: Color(0xFF3E4E39),
    accentText: Color(0xFFB1E457),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF9CA3AF),
    textMuted: Color(0xFFA1A1AA),
    textSoft: Color(0xFFD1D5DB),
    hint: Color(0xFF6B7280),
    error: Color(0xFFF87171),
    nameGradient: [Color(0xFFFDE047), Color(0xFFA3E635)],
  );

  static const light = AppColors(
    background: Color(0xFFF8FAFC),
    codeField: Color(0xFFE4E4E7),
    codeDash: Color(0xFF71717A),
    circle: Color(0xFFE2E8F0),
    card: Color(0xFFFFFFFF),
    accent: Color(0xFFB1E457),
    onAccent: Color(0xFF000000),
    onAccentBody: Color(0xFF1F2937),
    onAccentMuted: Color(0xFF3E4E39),
    accentText: Color(0xFF4D7C0F),
    textPrimary: Color(0xFF09090B),
    textSecondary: Color(0xFF6B7280),
    textMuted: Color(0xFF52525B),
    textSoft: Color(0xFF4B5563),
    hint: Color(0xFF9CA3AF),
    error: Color(0xFFDC2626),
    nameGradient: [Color(0xFFCA8A04), Color(0xFF65A30D)],
  );

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      background: mix(background, other.background),
      codeField: mix(codeField, other.codeField),
      codeDash: mix(codeDash, other.codeDash),
      circle: mix(circle, other.circle),
      card: mix(card, other.card),
      accent: mix(accent, other.accent),
      onAccent: mix(onAccent, other.onAccent),
      onAccentBody: mix(onAccentBody, other.onAccentBody),
      onAccentMuted: mix(onAccentMuted, other.onAccentMuted),
      accentText: mix(accentText, other.accentText),
      textPrimary: mix(textPrimary, other.textPrimary),
      textSecondary: mix(textSecondary, other.textSecondary),
      textMuted: mix(textMuted, other.textMuted),
      textSoft: mix(textSoft, other.textSoft),
      hint: mix(hint, other.hint),
      error: mix(error, other.error),
      nameGradient: [
        mix(nameGradient[0], other.nameGradient[0]),
        mix(nameGradient[1], other.nameGradient[1]),
      ],
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
