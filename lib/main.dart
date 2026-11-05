import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/notifications/notification_service.dart';
import 'core/providers/core_providers.dart';
import 'core/router/app_router.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );

  final notifications = NotificationService(FlutterLocalNotificationsPlugin());
  final launchRoom = await notifications.initialize();

  runApp(
    ProviderScope(
      overrides: [
        notificationServiceProvider.overrideWithValue(notifications),
        if (launchRoom != null)
          initialLocationProvider.overrideWithValue(AppRoutes.chat(launchRoom)),
      ],
      child: const CodeRoomApp(),
    ),
  );
}
