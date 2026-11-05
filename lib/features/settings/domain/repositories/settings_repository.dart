import '../entities/app_theme_mode.dart';

abstract interface class SettingsRepository {
  Future<AppThemeMode> themeMode();
  Future<void> saveThemeMode(AppThemeMode mode);
}
