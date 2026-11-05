import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

class SettingsLocalDataSource {
  const SettingsLocalDataSource(this._database);

  final AppDatabase _database;

  Future<String?> themeMode() async {
    final row = await _database.select(_database.appSettings).getSingleOrNull();
    return row?.themeMode;
  }

  Future<void> saveThemeMode(String mode) => _database
      .into(_database.appSettings)
      .insertOnConflictUpdate(
        AppSettingsCompanion.insert(id: const Value(0), themeMode: mode),
      );
}
