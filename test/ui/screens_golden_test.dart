import 'dart:io';

import 'package:code_room_chat_app/core/notifications/notification_service.dart';
import 'package:code_room_chat_app/core/providers/core_providers.dart';
import 'package:code_room_chat_app/core/theme/app_theme.dart';
import 'package:code_room_chat_app/features/chat/domain/entities/message.dart';
import 'package:code_room_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:code_room_chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:code_room_chat_app/features/chat/presentation/providers/chat_providers.dart';
import 'package:code_room_chat_app/features/room/domain/entities/room.dart';
import 'package:code_room_chat_app/features/room/domain/entities/room_identity.dart';
import 'package:code_room_chat_app/features/room/domain/repositories/room_repository.dart';
import 'package:code_room_chat_app/features/room/presentation/pages/join_room_page.dart';
import 'package:code_room_chat_app/features/room/presentation/pages/room_identity_page.dart';
import 'package:code_room_chat_app/features/room/presentation/providers/room_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show FlutterLocalNotificationsPlugin;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

class SilentNotifications extends NotificationService {
  SilentNotifications() : super(FlutterLocalNotificationsPlugin());

  @override
  Future<void> requestPermission() async {}
}

class StubRoomRepository implements RoomRepository {
  @override
  Stream<Room?> watchRoom(String code) =>
      Stream.value(Room(code: code, memberCount: 4));

  @override
  Stream<RoomIdentity?> watchIdentity(String code) => Stream.value(
    RoomIdentity(
      roomCode: code,
      uid: 'me',
      displayName: 'Brave Badger',
      acknowledged: true,
    ),
  );

  @override
  Stream<void> syncRoom(String code) => const Stream.empty();

  @override
  Future<void> acknowledgeIdentity(String code) async {}

  @override
  Future<RoomIdentity> createRoom() => throw UnimplementedError();

  @override
  Future<RoomIdentity> joinRoom(String code) => throw UnimplementedError();
}

class StubChatRepository implements ChatRepository {
  Message _message(String id, String sender, String name, String text) {
    final now = DateTime.now();
    final at = DateTime(now.year, now.month, now.day, 12);
    return Message(
      id: id,
      roomCode: '5812',
      senderId: sender,
      senderName: name,
      text: text,
      createdAt: at,
      sortAt: at,
      status: MessageStatus.sent,
    );
  }

  @override
  Stream<List<Message>> watchMessages(String roomCode, int limit) =>
      Stream.value([
        _message(
          'b',
          'me',
          'Brave Badger',
          'Hello! Visit a coffee shop on Amaranth st.',
        ),
        _message(
          'a',
          'other',
          'Pink Panthress',
          'Hi all! I came to visit your city for the weekend. '
              'Suggest coffee shop for breakfast with family.',
        ),
      ]);

  @override
  Stream<List<Message>> syncMessages(String roomCode) => const Stream.empty();

  @override
  Future<bool> loadOlder(String roomCode, int visibleCount) async => false;

  @override
  Future<void> sendMessage({
    required String roomCode,
    required String senderId,
    required String senderName,
    required String text,
  }) async {}
}

Future<void> loadFont(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final path in paths) {
    final bytes = File(path).readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

Future<void> loadFonts() async {
  final fonts = Directory('assets/fonts').listSync().whereType<File>();
  List<String> family(String prefix) => [
    for (final font in fonts)
      if (font.uri.pathSegments.last.startsWith(prefix)) font.path,
  ];
  await loadFont('Poppins', family('Poppins'));
  await loadFont('Urbanist', family('Urbanist'));
  await loadFont('PlusJakartaSans', family('PlusJakartaSans'));
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  await loadFont('MaterialIcons', [
    '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  ]);
}

Future<void> pumpScreen(
  WidgetTester tester,
  Widget page,
  ThemeData theme,
) async {
  tester.view.physicalSize = const Size(750, 1624);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        notificationServiceProvider.overrideWithValue(SilentNotifications()),
        roomRepositoryProvider.overrideWithValue(StubRoomRepository()),
        chatRepositoryProvider.overrideWithValue(StubChatRepository()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: page,
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  setUpAll(loadFonts);

  final screens = <String, Widget>{
    'join': const JoinRoomPage(),
    'identity': const RoomIdentityPage(roomCode: '5812'),
    'chat': const ChatPage(roomCode: '5812'),
  };

  for (final entry in screens.entries) {
    testWidgets('${entry.key} dark', (tester) async {
      debugDisableShadows = false;
      await pumpScreen(tester, entry.value, AppTheme.dark);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/${entry.key}_dark.png'),
      );
      debugDisableShadows = true;
    });

    testWidgets('${entry.key} light', (tester) async {
      debugDisableShadows = false;
      await pumpScreen(tester, entry.value, AppTheme.light);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/${entry.key}_light.png'),
      );
      debugDisableShadows = true;
    });
  }
}
