import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/settings_local_data_source.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/set_theme_mode.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepositoryImpl(
    SettingsLocalDataSource(ref.watch(appDatabaseProvider)),
  ),
);

final setThemeModeProvider = Provider(
  (ref) => SetThemeMode(ref.watch(settingsRepositoryProvider)),
);

final initialThemeModeProvider = Provider<AppThemeMode>(
  (ref) => AppThemeMode.system,
);

class ThemeModeController extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() => ref.read(initialThemeModeProvider);

  Future<void> select(AppThemeMode mode) async {
    state = mode;
    await ref.read(setThemeModeProvider)(mode);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeController, AppThemeMode>(
  ThemeModeController.new,
);
