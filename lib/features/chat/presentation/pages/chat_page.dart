import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_lifecycle_provider.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/widgets/room_header.dart';
import '../../../room/domain/entities/room_identity.dart';
import '../../../room/presentation/providers/room_providers.dart';
import '../../domain/entities/message.dart';
import '../providers/chat_providers.dart';
import '../utils/chat_item_builder.dart';
import '../widgets/date_separator.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_composer.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({required this.roomCode, super.key});

  final String roomCode;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  static const _loadMoreExtent = 300.0;

  final _scrollController = ScrollController();
  final _seenMessageIds = <String>{};
  var _hasRenderedHistory = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    ref.read(notificationServiceProvider).requestPermission();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.maxScrollExtent - position.pixels < _loadMoreExtent) {
      ref.read(chatHistoryProvider(widget.roomCode).notifier).loadMore();
    }
  }

  void _notify(List<Message> incoming, String? uid) {
    if (ref.read(appLifecycleProvider) == AppLifecycleState.resumed) return;
    final notifications = ref.read(notificationServiceProvider);
    for (final message in incoming) {
      if (message.senderId == uid) continue;
      notifications.showMessage(
        roomCode: message.roomCode,
        messageId: message.id,
        senderName: message.senderName,
        text: message.text,
      );
    }
  }

  void _send(RoomIdentity identity, String text) {
    ref.read(sendMessageProvider)(
      roomCode: identity.roomCode,
      senderId: identity.uid,
      senderName: identity.displayName,
      text: text,
    );
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
  }

  bool _shouldAnimate(Message message, int index) {
    final isNew = _seenMessageIds.add(message.id);
    return isNew && _hasRenderedHistory && index == 0;
  }

  @override
  Widget build(BuildContext context) {
    final roomCode = widget.roomCode;
    final identity = ref.watch(roomIdentityProvider(roomCode)).value;
    final room = ref.watch(roomProvider(roomCode)).value;
    final messages = ref.watch(messagesProvider(roomCode)).value;
    final items = buildChatItems(messages ?? const [], DateTime.now());
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final systemInset = MediaQuery.viewPaddingOf(context).bottom;

    ref.watch(roomSyncProvider(roomCode));
    ref.watch(appLifecycleProvider);
    ref.listen(chatSyncProvider(roomCode), (_, next) {
      final incoming = next.value;
      if (incoming != null) _notify(incoming, identity?.uid);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (messages != null) _hasRenderedHistory = true;
    });

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 80.2.h),
          RoomHeader(
            roomCode: roomCode,
            memberCount: room?.memberCount ?? 1,
            onBack: context.pop,
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: EdgeInsets.only(
                left: 15.1.w,
                right: 25.5.w,
                top: 16.w,
                bottom: 28.w,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) => switch (items[index]) {
                DateSeparatorItem(:final label) => DateSeparator(label: label),
                MessageItem(:final message) => Align(
                  alignment: message.senderId == identity?.uid
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: MessageBubble(
                    key: ValueKey(message.id),
                    message: message,
                    isMine: message.senderId == identity?.uid,
                    animate: _shouldAnimate(message, index),
                  ),
                ),
              },
            ),
          ),
          MessageComposer(
            onSend: (text) {
              if (identity != null) _send(identity, text);
            },
          ),
          SizedBox(height: keyboardOpen ? 8.w : max(35.h, systemInset + 8.w)),
        ],
      ),
    );
  }
}
