import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/room/presentation/pages/join_room_page.dart';
import '../../features/room/presentation/pages/room_identity_page.dart';

abstract final class AppRoutes {
  static const join = '/';
  static String identity(String code) => '/rooms/$code/identity';
  static String chat(String code) => '/rooms/$code/chat';
}

final initialLocationProvider = Provider<String>((ref) => AppRoutes.join);

CustomTransitionPage<void> _transition(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0.06, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: ref.watch(initialLocationProvider),
    routes: [
      GoRoute(
        path: AppRoutes.join,
        builder: (context, state) => const JoinRoomPage(),
        routes: [
          GoRoute(
            path: 'rooms/:code/identity',
            pageBuilder: (context, state) => _transition(
              state,
              RoomIdentityPage(roomCode: state.pathParameters['code']!),
            ),
          ),
          GoRoute(
            path: 'rooms/:code/chat',
            pageBuilder: (context, state) => _transition(
              state,
              ChatPage(roomCode: state.pathParameters['code']!),
            ),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
