import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/chat_local_data_source.dart';
import '../../data/datasources/chat_remote_data_source.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/load_older_messages.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/sync_messages.dart';
import '../../domain/usecases/watch_messages.dart';

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepositoryImpl(
    remote: FirestoreChatRemoteDataSource(ref.watch(firestoreProvider)),
    local: ChatLocalDataSource(ref.watch(appDatabaseProvider)),
    connectivity: ref.watch(connectivityServiceProvider),
  ),
);

final watchMessagesProvider = Provider(
  (ref) => WatchMessages(ref.watch(chatRepositoryProvider)),
);

final loadOlderMessagesProvider = Provider(
  (ref) => LoadOlderMessages(ref.watch(chatRepositoryProvider)),
);

final sendMessageProvider = Provider(
  (ref) => SendMessage(ref.watch(chatRepositoryProvider)),
);

final syncMessagesProvider = Provider(
  (ref) => SyncMessages(ref.watch(chatRepositoryProvider)),
);

class ChatHistoryState {
  const ChatHistoryState({required this.limit, required this.isLoadingMore});

  final int limit;
  final bool isLoadingMore;
}

class ChatHistoryController extends Notifier<ChatHistoryState> {
  ChatHistoryController(this.roomCode);

  final String roomCode;

  @override
  ChatHistoryState build() => const ChatHistoryState(
    limit: ChatRepositoryImpl.pageSize,
    isLoadingMore: false,
  );

  Future<void> loadMore() async {
    if (state.isLoadingMore) return;
    final limit = state.limit;
    state = ChatHistoryState(limit: limit, isLoadingMore: true);
    final revealed = await ref.read(loadOlderMessagesProvider)(roomCode, limit);
    if (!ref.mounted) return;
    state = ChatHistoryState(
      limit: revealed ? limit + ChatRepositoryImpl.pageSize : limit,
      isLoadingMore: false,
    );
  }
}

final chatHistoryProvider = NotifierProvider.autoDispose
    .family<ChatHistoryController, ChatHistoryState, String>(
      ChatHistoryController.new,
    );

final messagesProvider = StreamProvider.autoDispose
    .family<List<Message>, String>((ref, roomCode) {
      final limit = ref.watch(
        chatHistoryProvider(roomCode).select((state) => state.limit),
      );
      return ref.watch(watchMessagesProvider)(roomCode, limit);
    });

final chatSyncProvider = StreamProvider.autoDispose
    .family<List<Message>, String>(
      (ref, roomCode) => ref.watch(syncMessagesProvider)(roomCode),
    );
