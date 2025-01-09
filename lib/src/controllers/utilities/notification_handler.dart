import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint("Title : ${message.notification?.title}");
  debugPrint("Body : ${message.notification?.body}");
  debugPrint("Payload : ${message.data}");
}

class FirebaseApi {
  final navigatorKey = GlobalKey<NavigatorState>();
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'Hight Importance Notifications',
      description: 'This channel is used for importance notifications',
      importance: Importance.defaultImportance);
  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState?.pushNamed('/mainpage', arguments: message);
  }

  Future initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {
          // final message = RemoteMessage.fromMap(jsonDecode(payload));
          print("get Notif to local storage");
          // handleMessage(message)
        });

    final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  // coba untuk sent all notif for all user
  Future initPushNotificationsForAllUsers() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await FirebaseMessaging.instance.subscribeToTopic('all');
  }

  Future initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _firebaseMessaging.getInitialMessage().then((value) => handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(
          (message) {
        final notification = message.notification;
        if (notification == null) return;
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.toMap()),
        );
      },
    );
  }

  Future<void> initNotifications() async {
    print("Fungsi dijalankan initNotifications()");
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('player_id', fCMToken!);
    debugPrint("Player id in local storage is: ${prefs.getString('player_id')}");
    // test for all user
    _firebaseMessaging.subscribeToTopic('all');


    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    initPushNotifications();
    initLocalNotifications();
  }
}