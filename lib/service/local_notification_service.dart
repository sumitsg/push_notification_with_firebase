import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

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
      if (route!.isNotEmpty || route != null) {
        Navigator.of(context).pushNamed(route);
      }
    });
  }

  void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final String _bigPicture = await _downloadAndSaveFile(
          url:
              'https://images.unsplash.com/photo-1565958011703-44f9829ba187?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=765&q=80',
          fileName: 'bigPicture');
      final String _largeIcon = await _downloadAndSaveFile(
          url:
              'https://images.unsplash.com/photo-1653389527532-884074ac1c65?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1162&q=80',
          fileName: 'largeIcon');

      final _styleInfo = BigPictureStyleInformation(
        FilePathAndroidBitmap(_bigPicture),
        largeIcon: FilePathAndroidBitmap(_largeIcon),
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'push notification',
          'push notification channel',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          styleInformation: _styleInfo,
        ),
        iOS: const IOSNotificationDetails(),
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

  Future<String> _downloadAndSaveFile(
      {required String url, required String fileName}) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
