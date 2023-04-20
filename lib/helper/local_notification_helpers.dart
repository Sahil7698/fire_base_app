import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationHelper {
  LocalNotificationHelper._();

  static final LocalNotificationHelper localNotificationHelper =
      LocalNotificationHelper._();

  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotifications() async {
    var androidInitializationSettings =
        const AndroidInitializationSettings("mipmap/ic_launcher");
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("********************************");
        print("Payload => ${response.payload}");
        print("********************************");
      },
    );
  }

  Future<void> showSimpleNotification() async {
    var androidNotificationDetails = const AndroidNotificationDetails(
      "1",
      "Simple Channel",
      importance: Importance.max,
      priority: Priority.max,
    );
    var iosNotificationDetails = const DarwinNotificationDetails();

    var notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      1,
      "Simple Notification",
      "Dummy Body",
      notificationDetails,
      payload: "Sample Payload",
    );
  }

  Future<void> showScheduleNotification() async {
    var androidNotificationDetails = const AndroidNotificationDetails(
      "2",
      "Schedule Channel",
      importance: Importance.max,
      priority: Priority.max,
    );
    var iosNotificationDetails = const DarwinNotificationDetails();

    var notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        "Schedule Notification",
        "Dummy Body",
        tz.TZDateTime.now(tz.local).add(
          const Duration(seconds: 3),
        ),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: "Sample Payload");
  }

  Future<void> showBigPictureNotification() async {
    var bigPictureStyleNotification = const BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("mipmap/ic_launcher"),
      contentTitle: "Big Pic Notification",
      largeIcon: DrawableResourceAndroidBitmap("mipmap/ic_launcher"),
    );

    var androidNotificationDetails = AndroidNotificationDetails(
      "3",
      "Big Picture Channel",
      importance: Importance.max,
      priority: Priority.max,
      styleInformation: bigPictureStyleNotification,
    );
    var iosNotificationDetails = const DarwinNotificationDetails();

    var notificationDetails =
        NotificationDetails(android: androidNotificationDetails, iOS: null);

    await flutterLocalNotificationsPlugin.show(
      3,
      "Big Picture Notification",
      "Dummy Body",
      notificationDetails,
      payload: "Sample Payload",
    );
  }

  Future<void> showMediaStyleNotification() async {
    var androidNotificationDetails = const AndroidNotificationDetails(
      "4",
      "Media Style Channel",
      importance: Importance.max,
      priority: Priority.max,
      styleInformation: MediaStyleInformation(),
      largeIcon: DrawableResourceAndroidBitmap("mipmap/ic_launcher"),
      enableLights: true,
      colorized: true,
      color: Colors.red,
    );
    var iosNotificationDetails = const DarwinNotificationDetails();

    var notificationDetails =
        NotificationDetails(android: androidNotificationDetails, iOS: null);

    await flutterLocalNotificationsPlugin.show(
      4,
      "Media Style Notification",
      "Dummy Body",
      notificationDetails,
      payload: "Sample Payload",
    );
  }
}
