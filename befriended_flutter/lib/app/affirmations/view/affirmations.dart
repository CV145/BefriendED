import 'package:befriended_flutter/services/local_notification_service.dart';
import 'package:flutter/material.dart';

class AffirmationsPage extends StatefulWidget {
  const AffirmationsPage({Key? key}) : super(key: key);

  @override
  AffirmationsState createState() => AffirmationsState();
}

class AffirmationsState extends State<AffirmationsPage> {
  List<NotificationCard> cards = [];
  late final LocalNotificationService service;

  @override
  void initState() {
    //initialize the service
    service = LocalNotificationService();
    service.initialize();

    //adding item to list, you can add using json from network
    cards.add(
      NotificationCard(
        id: 1,
        notificationTime: const TimeOfDay(
          hour: 12,
          minute: 30,
        ),
        isEnabled: false,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Set Affirmation Reminders',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            //Children are mapped from list of cards
            children: cards.map((cardEntry) {
              return Card(
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        //Time Picker button
                        child: Text(
                          cardEntry.notificationTime.minute < 10
                              ? '${cardEntry.notificationTime.hour}:0${cardEntry.notificationTime.minute}'
                              : '${cardEntry.notificationTime.hour}:${cardEntry.notificationTime.minute}',
                        ),
                        onPressed:
                            () //anonymous/no-named function syntax that's async
                            async {
                          //final variables are not re-assigned
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          //Update card time
                          selectedTime == null
                              ? cardEntry.notificationTime =
                                  const TimeOfDay(hour: 12, minute: 0)
                              : cardEntry.notificationTime = selectedTime;

                          final nextDate = cardEntry.getNextDateTime();

                          //Update the next notification's DateTime
                          if (nextDate != null) {
                            await cardEntry.setupNotification(
                              service,
                              nextDate,
                            );
                          }
                          //Update UI
                          setState(() {});
                        },
                      ),
                      Switch(
                        //Enable button
                        value: cardEntry.isEnabled,
                        onChanged: (value) {
                          cardEntry.isEnabled = value;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        //Delete button
                        child: const Icon(Icons.delete),
                        onPressed: () {
                          /*delete action for this button
                        remove the element from list whose id matches this
                        card's id*/
                          cards.removeWhere((element) {
                            return element.id == cardEntry.id;
                          });
                          setState(() {
                            //refreshes the UI - making it match the card list
                          });
                        },
                      ),
                      ToggleButtons(
                        //Weekday buttons
                        onPressed: (int index) {
                          // All buttons are selectable.
                          setState(() {
                            cardEntry._chosenDays[index] =
                                !cardEntry._chosenDays[index];
                          });

                          final nextDate = cardEntry.getNextDateTime();

                          //Update the next notification's DateTime
                          if (nextDate != null) {
                            cardEntry.setupNotification(service, nextDate);
                          }
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        /*selectedBorderColor: Colors.green[700],
                        fillColor: Colors.green[200],
                        ,*/
                        selectedColor: Colors.blue[400],
                        color: Colors.white,
                        constraints: const BoxConstraints(
                          minHeight: 30,
                          minWidth: 30,
                        ),
                        isSelected: cardEntry._chosenDays,
                        children: weekdays,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //Add button
        elevation: 25,
        child: const Icon(Icons.add),
        onPressed: () async {
          final selectedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          final newID = cards.length + 1;
          final newCard = NotificationCard(
            id: newID,
            notificationTime: const TimeOfDay(hour: 12, minute: 0),
            isEnabled: true,
          );
          cards.add(newCard);
          selectedTime == null
              ? newCard.notificationTime = const TimeOfDay(hour: 12, minute: 0)
              : newCard.notificationTime = selectedTime;

          final nextDate = newCard.getNextDateTime();

          //Update the next notification's DateTime
          if (nextDate != null) {
            await newCard.setupNotification(service, nextDate);
          }
          setState(() {
            //UI refresh
            //Because the list may exist in code but won't show unless updated
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

//Modal class for NotificationCard object "model"
//required keyword means variable must be initialized through constructor
//This just contains the information ... which is stored in a list
//A ListTile or some other widget then REPRESENTS this information
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
  */
  final List<bool> _chosenDays = <bool>[
    true,
    true,
    true,
    true,
    true,
    true,
    true
  ];

  //Calling this method starts the notifications for this card
  Future<void> setupNotification(
    LocalNotificationService service,
    DateTime time,
  ) async {
    await service.setupScheduledNotification(
      id: id,
      title: 'Affirmation Test',
      body: 'Affirmation Quote',
      time: time,
    );
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
    if (currentTime.hour < notificationTime.hour &&
        currentTime.minute < notificationTime.minute &&
        _chosenDays[currentDayIndex]) {
      return DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        notificationTime.hour,
        notificationTime.minute,
      );
    } else if (currentTime.hour > notificationTime.hour) {
      //Get next active day
      if (_chosenDays.contains(true)) {
        var nextDayIndex = currentDayIndex;

        //Need to check if there's a new year/new month
        var nextDay = currentDate;

        do {
          //Search day by day to find the next date
          nextDayIndex++ > 6 ? nextDayIndex = 0 : nextDayIndex = nextDayIndex;
          nextDay = nextDay.add(const Duration(days: 1));

          if (_chosenDays[nextDayIndex]) {
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
