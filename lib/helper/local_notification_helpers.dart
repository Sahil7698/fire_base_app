import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationHelper {
  LocalNotificationHelper._();

  static final LocalNotificationHelper localNotificationHelper =
      LocalNotificationHelper._();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotifications() async {
    var androidInitializationSettings =
        const AndroidInitializationSettings("mipmap/ic_luncher");
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      print("********************************");
      print("Payload => ${response.payload}");
      print("********************************");
    });
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
        1, "Simple Notification", "Dummy Body", notificationDetails,
        payload: "Sample Payload");
  }
}
