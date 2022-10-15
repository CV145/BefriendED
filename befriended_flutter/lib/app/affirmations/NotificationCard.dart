//Modal class for NotificationCard object "model"
//required keyword means variable must be initialized through constructor
//This just contains the information ... which is stored in a list
//A ListTile or some other widget then REPRESENTS this information
import 'package:befriended_flutter/services/local_notification_service.dart';
import 'package:flutter/material.dart';

class NotificationCard {
  NotificationCard({
    required this.id,
    required this.notificationTime,
    required this.isEnabled,
  });

  int id;
  TimeOfDay notificationTime;
  bool isEnabled;

  /*
    There are 7 days. Index 0 = Monday. Index 6 = Sunday
    Note: The pointer is final, but the contents pointed to can change
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

  //Calling this method starts the scheduled notifications for this card
  Future<void> setupNotification(
      LocalNotificationService service,
      DateTime time,
      ) async {
    await service.setupScheduledNotification(
      id: id, //Card ID = Notification ID
      title: 'Affirmation Test',
      body: 'Affirmation Quote',
      time: time,
    );

    await service.showNotification(id: 1, title: 'Notification set!', body: '');
  }

  //The DateTime says the exact date and time of the next
  //notification
  /*
    There are 2 pieces of information we have: the daily time
    of the notification and the next day it will check relative
    to the current day.

    What time is it? Is the current time before or after
    the card's notification time?

    If it's before, what day is it? Is today a valid day on the
    card? If so, the next DateTime will be today at the requested
    time.

    If it's after, when's the next valid day? Is it tomorrow?
    The day after tomorrow? Once the next valid day is found,
    it will be stored in the next DateTime with the requested
    time.

    If there are no valid days, return null
  */
  DateTime? getNextDateTime() {
    final currentTime = TimeOfDay.now();
    final currentDate = DateTime.now();
    final currentDayIndex = currentDate.weekday - 1;

    //Consider the hour first, then the minute, then check if today is a good
    //day to notify the user
    if (currentTime.hour <= notificationTime.hour &&
        currentTime.minute <= notificationTime.minute &&
        chosenDays[currentDayIndex]) {
      return DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        notificationTime.hour,
        notificationTime.minute,
      );
    } else if (currentTime.hour > notificationTime.hour) {
      //Get next active day
      if (chosenDays.contains(true)) {
        var nextDayIndex = currentDayIndex;

        //Need to check if there's a new year/new month
        var nextDay = currentDate;

        do {
          //Search day by day to find the next date
          nextDayIndex++ > 6 ? nextDayIndex = 0 : nextDayIndex = nextDayIndex;
          nextDay = nextDay.add(const Duration(days: 1));

          if (chosenDays[nextDayIndex]) {
            return DateTime(
              nextDay.year,
              nextDay.month,
              nextDay.day,
              notificationTime.hour,
              notificationTime.minute,
            );
          }
        } while (nextDayIndex != currentDayIndex);
      }
    }

    return null;
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
