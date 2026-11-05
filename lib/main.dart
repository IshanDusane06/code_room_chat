import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/notifications/notification_service.dart';
import 'core/providers/core_providers.dart';
import 'core/router/app_router.dart';
import 'features/settings/data/datasources/settings_local_data_source.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/usecases/get_theme_mode.dart';
import 'features/settings/presentation/providers/settings_providers.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );

  final notifications = NotificationService(FlutterLocalNotificationsPlugin());
  final launchRoom = await notifications.initialize();
  final database = AppDatabase();
  final themeMode = await GetThemeMode(
    SettingsRepositoryImpl(SettingsLocalDataSource(database)),
  )();

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        notificationServiceProvider.overrideWithValue(notifications),
        initialThemeModeProvider.overrideWithValue(themeMode),
        if (launchRoom != null)
          initialLocationProvider.overrideWithValue(AppRoutes.chat(launchRoom)),
      ],
      child: const CodeRoomApp(),
    ),
  );
}
