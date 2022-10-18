import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

//need to add IOS notification services
//only Android services implemented
class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidInitializationSettings =
        AndroidInitializationSettings('@drawable/ic_stat_favorite');

    //const IOSInitializationSettings iosInitializationSettings =
    //IOSInitializationSettings();

    const settings =
        InitializationSettings(android: androidInitializationSettings);

    await _localNotificationService.initialize(
      settings,
      onSelectNotification: onSelectNotification,
    );
  }

  //Return NotificationDetails in the 'future'
  Future<NotificationDetails> _getNotificationDetails() async {
    //Widget for android notification details
    const androidNotificationDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
    );

    return const NotificationDetails(android: androidNotificationDetails);
  }

  //Show an instant notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _getNotificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  //Show a notification after the given seconds pass (delayed)
  Future<void> showDelayedNotification({
    required int id,
    required String title,
    required String body,
    required int seconds,
  }) async {
    final details = await _getNotificationDetails();
    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        DateTime.now().add(Duration(seconds: seconds)),
        tz.local,
      ),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  //Show a notification at the given DateTime (an object that contains info on a
  //date: day, hour, minute) - repeat at the same day of the week and time
  Future<void> setupScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    try {
      await _localNotificationService.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(time, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your channel id',
            'your channel name',
            channelDescription: 'your channel description',
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );

      await showNotification(
        id: 0,
        title: 'Notification Set!',
        body: 'Next notification at: $time',
      );
    } catch (e) {
      //add toast message here to notify user of error
      await showNotification(
        id: 0,
        title: 'Scheduled notification error',
        body: e.toString(),
      );
    }
  }

  //Cancel the given notification
  Future<void> cancelNotification(int givenID)
  async {
    await _localNotificationService.cancel(givenID);
    await showNotification(
        id: 0,
        title: 'Notification $givenID cancelled', body: '',
    );

    print('Notification $givenID cancelled');
  }

  void onSelectNotification(String? payload) {
    print('payload $payload');
  }
}
