import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLifecycleNotifier extends Notifier<AppLifecycleState> {
  @override
  AppLifecycleState build() {
    final listener = AppLifecycleListener(
      onStateChange: (next) => state = next,
    );
    ref.onDispose(listener.dispose);
    return WidgetsBinding.instance.lifecycleState ?? AppLifecycleState.resumed;
  }
}

final appLifecycleProvider =
    NotifierProvider<AppLifecycleNotifier, AppLifecycleState>(
      AppLifecycleNotifier.new,
    );
