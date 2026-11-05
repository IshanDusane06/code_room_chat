import 'dart:async';
import 'dart:math';

import 'package:uuid/uuid.dart';

import '../../../../core/network/connectivity_service.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_data_source.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required this._remote,
    required this._local,
    required this._connectivity,
    this._uuid = const Uuid(),
    this._retryDelay = const Duration(seconds: 5),
  });

  static const pageSize = 30;
  static const _sendTimeout = Duration(seconds: 15);

  final ChatRemoteDataSource _remote;
  final ChatLocalDataSource _local;
  final ConnectivityService _connectivity;
  final Uuid _uuid;
  final Duration _retryDelay;
  final Set<String> _neverAttempted = {};
  final Map<String, Future<bool>> _drains = {};
  final Set<String> _drainRequested = {};

  @override
  Stream<List<Message>> watchMessages(String roomCode, int limit) =>
      _local.watchMessages(roomCode, limit);

  @override
  Future<bool> loadOlder(String roomCode, int visibleCount) async {
    if (await _local.countMessages(roomCode) > visibleCount) return true;
    if (!await _local.hasMoreHistory(roomCode)) return false;
    if (!await _connectivity.isOnline) return false;
    final oldest = await _local.oldestServerMicros(roomCode);
    if (oldest == null) return false;
    try {
      final page = await _remote.fetchUpTo(roomCode, oldest, pageSize + 1);
      if (page.isNotEmpty) await _local.upsertRemote(page);
      if (page.length <= pageSize) {
        await _local.setHasMoreHistory(roomCode, false);
      }
    } on Exception {
      return false;
    }
    return await _local.countMessages(roomCode) > visibleCount;
  }

  @override
  Future<void> sendMessage({
    required String roomCode,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    final newest = await _local.newestServerMicros(roomCode) ?? 0;
    final now = DateTime.now().microsecondsSinceEpoch;
    final message = Message(
      id: _uuid.v4(),
      roomCode: roomCode,
      senderId: senderId,
      senderName: senderName,
      text: text,
      createdAt: null,
      sortAt: DateTime.fromMicrosecondsSinceEpoch(max(now, newest + 1)),
      status: MessageStatus.pending,
    );
    await _local.insertPending(message);
    _neverAttempted.add(message.id);
    if (await _connectivity.isOnline) await _drain(roomCode);
  }

  @override
  Stream<List<Message>> syncMessages(String roomCode) {
    late final StreamController<List<Message>> controller;
    StreamSubscription<List<MessageModel>>? remote;
    StreamSubscription<bool>? connectivity;
    var generation = 0;

    Future<void> stop() async {
      generation++;
      await remote?.cancel();
      remote = null;
    }

    Future<void> start() async {
      await stop();
      final current = generation;
      try {
        await _seed(roomCode);
        final from = await _local.newestServerMicros(roomCode);
        if (current != generation) return;
        remote = _remote.watchFrom(roomCode, from).listen((models) async {
          final added = await _local.upsertRemote(models);
          if (added.isNotEmpty && !controller.isClosed) {
            controller.add(added.map(_toEntity).toList());
          }
        }, onError: (Object _) {});
        while (current == generation && !await _drain(roomCode)) {
          await Future<void>.delayed(_retryDelay);
        }
      } on Exception {
        return;
      }
    }

    controller = StreamController<List<Message>>(
      onListen: () {
        connectivity = _connectivity.onlineChanges.listen(
          (online) => online ? start() : stop(),
        );
        start();
      },
      onCancel: () async {
        await connectivity?.cancel();
        await stop();
      },
    );
    return controller.stream;
  }

  Future<void> _seed(String roomCode) async {
    if (await _local.newestServerMicros(roomCode) != null) return;
    final latest = await _remote.fetchLatest(roomCode, pageSize);
    if (latest.isNotEmpty) await _local.upsertRemote(latest);
    if (latest.length < pageSize) {
      await _local.setHasMoreHistory(roomCode, false);
    }
  }

  Future<bool> _drain(String roomCode) {
    final running = _drains[roomCode];
    if (running != null) {
      _drainRequested.add(roomCode);
      return running;
    }
    final drain = _drainInOrder(roomCode).whenComplete(() {
      _drains.remove(roomCode);
    });
    _drains[roomCode] = drain;
    return drain;
  }

  Future<bool> _drainInOrder(String roomCode) async {
    do {
      _drainRequested.remove(roomCode);
      for (final message in await _local.pendingMessages(roomCode)) {
        if (!await _deliver(message)) return false;
      }
    } while (_drainRequested.contains(roomCode));
    return true;
  }

  Future<bool> _deliver(Message message) async {
    try {
      if (!_neverAttempted.remove(message.id)) {
        final existing = await _remote
            .fetchMessage(message.roomCode, message.id)
            .timeout(_sendTimeout);
        if (existing != null) {
          await _local.upsertRemote([existing]);
          return true;
        }
      }
      await _remote.send(message).timeout(_sendTimeout);
      return true;
    } on Exception {
      return false;
    }
  }

  Message _toEntity(MessageModel model) {
    final createdAt = DateTime.fromMicrosecondsSinceEpoch(
      model.createdAtMicros,
    );
    return Message(
      id: model.id,
      roomCode: model.roomCode,
      senderId: model.senderId,
      senderName: model.senderName,
      text: model.text,
      createdAt: createdAt,
      sortAt: createdAt,
      status: MessageStatus.sent,
    );
  }
}
