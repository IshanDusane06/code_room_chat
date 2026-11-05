import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Rooms, RoomIdentities, Messages])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'code_room'));

  @override
  int get schemaVersion => 1;
}
