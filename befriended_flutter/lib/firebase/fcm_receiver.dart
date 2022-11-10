import 'package:befriended_flutter/services/android_local_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// This class sets up a client that will receive Firebase Cloud Messages
class FCMReceiver
{
  static const String tag = 'ch9';

  void onMessageReceived(RemoteMessage remoteMessage)
  {
    //Check if message contains a data payload
    if (remoteMessage.data.isNotEmpty) {
      print('Message received. Message data payload: ${remoteMessage.data}');
    }

    //Check if message contains a notification payload
    if (remoteMessage.notification != null) {
      print('Message notification body: ${remoteMessage.notification?.body}');
    }

    var message = remoteMessage.notification?.body;

    sendNotification(message ?? '');
  }

  //Send an immediate notification using the given message
  void sendNotification(String message)
  {
    var service = AndroidLocalNotificationService()
    ..showNotification(id: 0, title: 'New notification', body: message);
  }
}
