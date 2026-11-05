import '../entities/app_theme_mode.dart';
import '../repositories/settings_repository.dart';

class GetThemeMode {
  const GetThemeMode(this._repository);

  final SettingsRepository _repository;

  Future<AppThemeMode> call() => _repository.themeMode();
}
