import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/room_local_data_source.dart';
import '../../data/datasources/room_remote_data_source.dart';
import '../../data/repositories/room_repository_impl.dart';
import '../../data/services/name_generator.dart';
import '../../data/services/room_code_generator.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/room_identity.dart';
import '../../domain/repositories/room_repository.dart';
import '../../domain/usecases/acknowledge_identity.dart';
import '../../domain/usecases/create_room.dart';
import '../../domain/usecases/join_room.dart';
import '../../domain/usecases/sync_room.dart';
import '../../domain/usecases/watch_room.dart';
import '../../domain/usecases/watch_room_identity.dart';

final roomRepositoryProvider = Provider<RoomRepository>(
  (ref) => RoomRepositoryImpl(
    remote: FirestoreRoomRemoteDataSource(
      ref.watch(firestoreProvider),
      ref.watch(firebaseAuthProvider),
    ),
    local: RoomLocalDataSource(ref.watch(appDatabaseProvider)),
    connectivity: ref.watch(connectivityServiceProvider),
    nameGenerator: NameGenerator(),
    codeGenerator: RoomCodeGenerator(),
  ),
);

final createRoomProvider = Provider(
  (ref) => CreateRoom(ref.watch(roomRepositoryProvider)),
);

final joinRoomProvider = Provider(
  (ref) => JoinRoom(ref.watch(roomRepositoryProvider)),
);

final acknowledgeIdentityProvider = Provider(
  (ref) => AcknowledgeIdentity(ref.watch(roomRepositoryProvider)),
);

final watchRoomProvider = Provider(
  (ref) => WatchRoom(ref.watch(roomRepositoryProvider)),
);

final watchRoomIdentityProvider = Provider(
  (ref) => WatchRoomIdentity(ref.watch(roomRepositoryProvider)),
);

final syncRoomProvider = Provider(
  (ref) => SyncRoom(ref.watch(roomRepositoryProvider)),
);

final roomProvider = StreamProvider.autoDispose.family<Room?, String>(
  (ref, code) => ref.watch(watchRoomProvider)(code),
);

final roomIdentityProvider = StreamProvider.autoDispose
    .family<RoomIdentity?, String>(
      (ref, code) => ref.watch(watchRoomIdentityProvider)(code),
    );

final roomSyncProvider = StreamProvider.autoDispose.family<void, String>(
  (ref, code) => ref.watch(syncRoomProvider)(code),
);
