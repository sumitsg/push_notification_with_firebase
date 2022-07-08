// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_notification_with_firebase/greenpage.dart';
import 'package:push_notification_with_firebase/redpage.dart';
import 'package:push_notification_with_firebase/service/local_notification_service.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   "id",
//   "notification",
//   playSound: true,
//   importance: Importance.high,
// );
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

FlutterLocalNotificationsPlugin flutter = FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const MyHomePage(title: 'Push Notification '),
      routes: {
        'red': (_) => const RedPage(),
        'green': (_) => const GreenPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    LocalNotificationService.initilize(context);

    /// gives you the message on which user taps
    /// and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMsg = message.data['route'];
        Navigator.of(context).pushNamed(routeFromMsg);
      }
    });
    //
    // only work when app is in forground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }
      LocalNotificationService().display(message);
    });

    // when app is in background in running state and user taps on that notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }
      if (message.data.isNotEmpty) {
        final routeName = message.data['route'];
        Navigator.of(context).pushNamed(routeName);
      } else {
        print('route is null');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Center(
            child: Text('You will receive massage soon',
                style: TextStyle(fontSize: 34)),
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
