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
  })
  {
    storedDateTime = getNextDateTime();
  }

  int id;
  TimeOfDay notificationTime;
  bool isEnabled;
  late DateTime storedDateTime;

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

  //Cancel this card's notification
  void toggleNotification({required bool cancelThisCard,
    required LocalNotificationService service,})
  {
    /*
    A card notification's ID is the same as the card ID
     */
    if (cancelThisCard)
    {
      service.cancelNotification(id);
      print('Notification cancelled');
    }
    else
    {
     setupNotification(service, storedDateTime);
    }

  }

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

  //The DateTime says the exact date and time of the next notification
  DateTime getNextDateTime() {
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

    final Error error =
    ArgumentError('Error grabbing next DateTime for notification card: $id');
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
