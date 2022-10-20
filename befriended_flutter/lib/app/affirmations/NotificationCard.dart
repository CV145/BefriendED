//Modal class for NotificationCard object "model"
//required keyword means variable must be initialized through constructor
//This just contains the information ... which is stored in a list
//A ListTile or some other widget then REPRESENTS this information
import 'package:befriended_flutter/services/local_notification_service.dart';
import 'package:flutter/material.dart';

class NotificationCard {
  NotificationCard({
    required this.id,
    required this.affirmationTime,
    required this.isEnabled,
  });

  int id;
  TimeOfDay affirmationTime = const TimeOfDay(hour: 12, minute: 0);
  bool isEnabled;
  late DateTime nextNotificationTime;

  /*
    There are 7 days. Index 0 = Monday. Index 6 = Sunday
    Note: The pointer address is final, but the contents pointed to can change
  */
  final List<bool> chosenDays = <bool>[
    true,
    true,
    true,
    true,
    true,
    true,
    true
  ];

  //Simply disable the notification
  void cancelNotification(LocalNotificationService service) {
    service.cancelNotification(id);
  }

  //Update the notification with this card's ID
  Future<void> scheduleNotification(
    LocalNotificationService service,
  ) async {
    getNextNotificationTime();
    await service.setupScheduledNotification(
      id: id, //Card ID = Notification ID
      title: 'Affirmation Test',
      body: 'Affirmation Quote',
      time: nextNotificationTime,
    );
    await service.showNotification(id: 1, title: 'Notification set!', body: '');
    print('Notification set');
  }

  //The DateTime says the exact date and time of the next notification
  void getNextNotificationTime() {
    final currentTime = TimeOfDay.now();
    final currentDate = DateTime.now();
    final currentDayIndex = currentDate.weekday - 1;

    print('Time: $affirmationTime for card #$id');
    print('Current day index: $currentDayIndex');

    /* check if today is a good day to notify the user if one of these
    conditions are true:
    - current hour is before affirmation hour and today is valid
    - current hour matches affirmation hour and minute is before affirmation
    minute and today is valid
     */
    if ((currentTime.hour < affirmationTime.hour &&
            chosenDays[currentDayIndex]) ||
        (currentTime.hour == affirmationTime.hour &&
            currentTime.minute < affirmationTime.minute &&
            chosenDays[currentDayIndex])) {
      nextNotificationTime = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        affirmationTime.hour,
        affirmationTime.minute,
      );
      return;
    } else
    {
      if (chosenDays.contains(true)) {
        //Get next active day
        var nextDayIndex = currentDayIndex;

        //Need to check if there's a new year/new month
        var nextDate = currentDate;

        do {
          //Search day by day to find the next date
          nextDayIndex++;
          if (nextDayIndex > 6)
          {
            nextDayIndex = 0;
          }

          print('Date before adding 1 day: $nextDate');
          //Add 1 day to the date
          nextDate = nextDate.add(const Duration(days: 1));
          print('Date after adding 1 day: $nextDate');

          print('Considering day: $nextDayIndex');
          print('Considering date: $nextDate');

          //If the next day is valid, set the notification time on it
          if (chosenDays[nextDayIndex]) {
            nextNotificationTime = DateTime(
              nextDate.year,
              nextDate.month,
              nextDate.day,
              affirmationTime.hour,
              affirmationTime.minute,
            );
            return;
          }
          else
          {
            print('Day invalid');
          }
        } while (nextDayIndex != currentDayIndex);
      }
    }

    final Error error = ArgumentError(
        'Error grabbing next DateTime for notification card: $id',);
    throw error;
  }
}

//Global list of days of the week
//Allows quick use anywhere
const List<Widget> weekdays = <Widget>[
  Text(
    'Mon',
    style: TextStyle(fontSize: 10),
  ),
  Text(
    'Tue',
    style: TextStyle(fontSize: 10),
  ),
  Text(
    'Wed',
    style: TextStyle(fontSize: 10),
  ),
  Text(
    'Thu',
    style: TextStyle(fontSize: 10),
  ),
  Text(
    'Fri',
    style: TextStyle(fontSize: 10),
  ),
  Text(
    'Sat',
    style: TextStyle(fontSize: 10),
  ),
  Text(
    'Sun',
    style: TextStyle(fontSize: 10),
  ),
];
