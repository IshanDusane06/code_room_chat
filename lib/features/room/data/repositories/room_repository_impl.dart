import 'dart:async';

import 'package:firebase_core/firebase_core.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/room_identity.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/room_local_data_source.dart';
import '../datasources/room_remote_data_source.dart';
import '../models/room_model.dart';
import '../services/name_generator.dart';
import '../services/room_code_generator.dart';

class RoomRepositoryImpl implements RoomRepository {
  RoomRepositoryImpl({
    required this._remote,
    required this._local,
    required this._connectivity,
    required this._nameGenerator,
    required this._codeGenerator,
  });

  static const _maxCodeAttempts = 5;
  static const _networkTimeout = Duration(seconds: 12);

  final RoomRemoteDataSource _remote;
  final RoomLocalDataSource _local;
  final ConnectivityService _connectivity;
  final NameGenerator _nameGenerator;
  final RoomCodeGenerator _codeGenerator;

  @override
  Future<RoomIdentity> createRoom() => _online(() async {
    final uid = await _remote.ensureSignedIn();
    final displayName = _nameGenerator.generate(const {});
    for (var attempt = 0; attempt < _maxCodeAttempts; attempt++) {
      final code = _codeGenerator.generate();
      try {
        await _remote.createRoom(
          code: code,
          uid: uid,
          displayName: displayName,
        );
      } on RoomCodeTakenException {
        continue;
      }
      return _saveMembership(
        RoomModel(code: code, memberCount: 1),
        uid,
        displayName,
      );
    }
    throw const UnexpectedFailure();
  });

  @override
  Future<RoomIdentity> joinRoom(String code) async {
    final existing = await _local.getIdentity(code);
    if (existing != null) return existing;
    return _online(() async {
      final uid = await _remote.ensureSignedIn();
      final room = await _remote.fetchRoom(code);
      if (room == null) throw const RoomNotFoundFailure();
      final knownName = await _remote.fetchMemberName(code, uid);
      if (knownName != null) return _saveMembership(room, uid, knownName);
      final taken = await _remote.fetchMemberNames(code);
      final displayName = _nameGenerator.generate(taken);
      await _remote.addMember(code: code, uid: uid, displayName: displayName);
      return _saveMembership(
        RoomModel(
          code: room.code,
          memberCount: room.memberCount + 1,
          createdAtMicros: room.createdAtMicros,
        ),
        uid,
        displayName,
      );
    });
  }

  @override
  Future<void> acknowledgeIdentity(String code) => _local.acknowledge(code);

  @override
  Stream<Room?> watchRoom(String code) => _local.watchRoom(code);

  @override
  Stream<RoomIdentity?> watchIdentity(String code) =>
      _local.watchIdentity(code);

  @override
  Stream<void> syncRoom(String code) => _remote
      .watchRoom(code)
      .asyncMap(_local.saveRoom)
      .handleError((Object _) {});

  Future<RoomIdentity> _saveMembership(
    RoomModel room,
    String uid,
    String displayName,
  ) async {
    final identity = RoomIdentity(
      roomCode: room.code,
      uid: uid,
      displayName: displayName,
      acknowledged: false,
    );
    await _local.saveMembership(room, identity);
    return identity;
  }

  Future<T> _online<T>(Future<T> Function() action) async {
    if (!await _connectivity.isOnline) throw const OfflineFailure();
    try {
      return await action().timeout(_networkTimeout);
    } on Failure {
      rethrow;
    } on TimeoutException {
      throw const OfflineFailure();
    } on FirebaseException catch (error) {
      if (error.code == 'unavailable' ||
          error.code == 'network-request-failed') {
        throw const OfflineFailure();
      }
      throw const UnexpectedFailure();
    }
  }
}
