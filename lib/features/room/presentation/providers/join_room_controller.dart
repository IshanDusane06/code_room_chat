import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/room_identity.dart';
import 'room_providers.dart';

sealed class JoinRoomState {
  const JoinRoomState();
}

final class JoinRoomIdle extends JoinRoomState {
  const JoinRoomIdle();
}

final class JoinRoomLoading extends JoinRoomState {
  const JoinRoomLoading();
}

final class JoinRoomFailed extends JoinRoomState {
  const JoinRoomFailed(this.message);

  final String message;
}

final class JoinRoomSucceeded extends JoinRoomState {
  const JoinRoomSucceeded(this.identity);

  final RoomIdentity identity;
}

class JoinRoomController extends Notifier<JoinRoomState> {
  @override
  JoinRoomState build() => const JoinRoomIdle();

  Future<void> join(String code) =>
      _run(() => ref.read(joinRoomProvider)(code));

  Future<void> create() => _run(() => ref.read(createRoomProvider)());

  void reset() => state = const JoinRoomIdle();

  Future<void> _run(Future<RoomIdentity> Function() action) async {
    if (state is JoinRoomLoading) return;
    state = const JoinRoomLoading();
    try {
      state = JoinRoomSucceeded(await action());
    } on Failure catch (failure) {
      state = JoinRoomFailed(failure.message);
    } on Exception {
      state = JoinRoomFailed(const UnexpectedFailure().message);
    }
  }
}

final joinRoomControllerProvider =
    NotifierProvider<JoinRoomController, JoinRoomState>(JoinRoomController.new);
