import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future initilize(BuildContext context) async {
    // const InitializationSettings initializationSettings =
    //     InitializationSettings(
    //   android: AndroidInitializationSettings('ic_launcher'),
    //   iOS: IOSInitializationSettings(),
    // );

    // _flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: (String? route) async {
    //   if (route != null) {
    //     Navigator.of(context).pushNamed(route);
    //   }
    // });
    FlutterLocalNotificationsPlugin ftlrPluggin =
        FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    IOSInitializationSettings iosInitializationSettings =
        const IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await ftlrPluggin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      if (route != null) {
        Navigator.of(context).pushNamed(route);
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      NotificationDetails notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
          'push notification',
          'push notification channel',
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: IOSNotificationDetails(),
      );

      await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['route'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
