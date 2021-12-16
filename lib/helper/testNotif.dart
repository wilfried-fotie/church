import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('@drawable/ic_launcher');
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('splash');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(
      int id, String title, String body, int seconds) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        // tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
        // tz.TZDateTime.from(
        //     DateTime.now().add(const Duration(seconds: 12)), tz.local),
        _nextInstanceOfTenAM(const Time(13, 20)),
        const NotificationDetails(
          android: AndroidNotificationDetails('main_channel', 'Main Channel',
              importance: Importance.max,
              priority: Priority.max,
              icon: '@drawable/splash'),
          iOS: IOSNotificationDetails(
            sound: 'default.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // Future<void> scheduleDailyTenAMNotification() async {
  //   print("Yema");
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       "Bonjour ...",
  //       "La méditation du jour est déjà disponible ",
  //       _nextInstanceOfTenAM(Time(8)),
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails('daily notification channel id',
  //             'daily notification channel name',
  //             channelDescription: 'daily notification description'),
  //       ),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time);
  // }

  tz.TZDateTime _nextInstanceOfTenAM(Time time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, time.hour, time.minute, time.second);

    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }
}
