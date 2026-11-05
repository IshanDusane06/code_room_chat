import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../network/connectivity_service.dart';
import '../notifications/notification_service.dart';

final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityPlusService(Connectivity()),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError(),
);
