import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

//need to add IOS notification services
//only Android services implemented
class LocalNotificationService
{
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async
  {
    tz.initializeTimeZones();

    const androidInitializationSettings =
        AndroidInitializationSettings('@drawable/ic_stat_favorite');

    //const IOSInitializationSettings iosInitializationSettings =
      //IOSInitializationSettings();

    const settings = InitializationSettings(
      android: androidInitializationSettings
    );

    await _localNotificationService.initialize(
        settings, 
        onSelectNotification: onSelectNotification);
  }

  //Return NotificationDetails in the 'future'
  Future<NotificationDetails> _notificationDetails() async
  {
    //Widget for android notification details
    const androidNotificationDetails =
    AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
    );

    return NotificationDetails(android: androidNotificationDetails);
  }

  Future<void> showNotification
  ({
    required int id,
    required String title,
    required String body,
  }) async
  {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  Future<void> showScheduledNotification
  ({
    required int id,
    required String title,
    required String body,
    required int seconds,
  }) async
  {
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule
      ( id, title, body,
        tz.TZDateTime.from(DateTime.now().add(Duration(seconds: seconds)), tz.local),
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
  }

  void onSelectNotification(String? payload) {
    print('payload $payload');
  }
}