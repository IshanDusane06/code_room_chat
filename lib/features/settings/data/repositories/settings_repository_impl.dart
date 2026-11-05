import '../../domain/entities/app_theme_mode.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._local);

  final SettingsLocalDataSource _local;

  @override
  Future<AppThemeMode> themeMode() async =>
      AppThemeMode.values.asNameMap()[await _local.themeMode()] ??
      AppThemeMode.system;

  @override
  Future<void> saveThemeMode(AppThemeMode mode) =>
      _local.saveThemeMode(mode.name);
}
