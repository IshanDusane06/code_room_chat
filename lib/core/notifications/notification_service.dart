import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService(this._plugin);

  static const _channelId = 'room_messages';
  static const _channelName = 'Room messages';

  final FlutterLocalNotificationsPlugin _plugin;
  void Function(String roomCode)? onRoomSelected;

  Future<String?> initialize() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        final roomCode = response.payload;
        if (roomCode != null) onRoomSelected?.call(roomCode);
      },
    );
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      return launch?.notificationResponse?.payload;
    }
    return null;
  }

  Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> showMessage({
    required String roomCode,
    required String messageId,
    required String senderName,
    required String text,
  }) => _plugin.show(
    id: messageId.hashCode,
    title: 'Room #$roomCode',
    body: '@${senderName.replaceAll(' ', '')}: $text',
    payload: roomCode,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
  );
}
