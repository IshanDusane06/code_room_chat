import 'package:code_room_chat_app/core/database/app_database.dart';
import 'package:code_room_chat_app/core/providers/core_providers.dart';
import 'package:code_room_chat_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:code_room_chat_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:code_room_chat_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:code_room_chat_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:code_room_chat_app/features/settings/presentation/widgets/theme_toggle_button.dart';
import 'package:code_room_chat_app/core/theme/app_theme.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late SettingsRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = SettingsRepositoryImpl(SettingsLocalDataSource(database));
  });

  tearDown(() => database.close());

  group('repository', () {
    test('follows the system until a theme is chosen', () async {
      expect(await repository.themeMode(), AppThemeMode.system);
    });

    test('keeps only the latest choice', () async {
      await repository.saveThemeMode(AppThemeMode.light);
      await repository.saveThemeMode(AppThemeMode.dark);

      expect(await repository.themeMode(), AppThemeMode.dark);
      expect(await database.select(database.appSettings).get(), hasLength(1));
    });
  });

  group('controller', () {
    test('starts from the saved theme and persists a new one', () async {
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          initialThemeModeProvider.overrideWithValue(AppThemeMode.dark),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), AppThemeMode.dark);

      await container
          .read(themeModeProvider.notifier)
          .select(AppThemeMode.light);

      expect(container.read(themeModeProvider), AppThemeMode.light);
      expect(await repository.themeMode(), AppThemeMode.light);
    });
  });

  group('toggle', () {
    Future<ProviderContainer> pump(WidgetTester tester, ThemeData theme) async {
      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, _) => MaterialApp(
              theme: theme,
              home: const Scaffold(body: ThemeToggleButton()),
            ),
          ),
        ),
      );
      return container;
    }

    testWidgets('switches a dark screen to light', (tester) async {
      final container = await pump(tester, AppTheme.dark);

      await tester.tap(find.byType(ThemeToggleButton));

      expect(container.read(themeModeProvider), AppThemeMode.light);
    });

    testWidgets('switches a light screen to dark', (tester) async {
      final container = await pump(tester, AppTheme.light);

      await tester.tap(find.byType(ThemeToggleButton));

      expect(container.read(themeModeProvider), AppThemeMode.dark);
    });
  });

  test('upgrading from version 1 keeps rooms and adds settings', () async {
    final upgraded = AppDatabase(
      NativeDatabase.memory(
        setup: (raw) {
          raw.execute('''
            CREATE TABLE rooms (
              code TEXT NOT NULL PRIMARY KEY,
              member_count INTEGER NOT NULL DEFAULT 1,
              created_at_micros INTEGER NULL,
              has_more_history INTEGER NOT NULL DEFAULT 1
            )
          ''');
          raw.execute("INSERT INTO rooms (code) VALUES ('655994')");
          raw.execute('PRAGMA user_version = 1');
        },
      ),
    );
    addTearDown(upgraded.close);

    final rooms = await upgraded.select(upgraded.rooms).get();
    final settings = SettingsRepositoryImpl(SettingsLocalDataSource(upgraded));
    await settings.saveThemeMode(AppThemeMode.light);

    expect(rooms.single.code, '655994');
    expect(await settings.themeMode(), AppThemeMode.light);
  });
}
