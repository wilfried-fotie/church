import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notofication {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails("channel id", "channel name",
            importance: Importance.max),
        iOS: IOSNotificationDetails());
  }

  static Future showNotif({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      {
        _notifications.show(id, title, body, await notificationDetails(),
            payload: 'item x')
      };
}
