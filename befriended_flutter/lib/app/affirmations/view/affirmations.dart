import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:weekday_selector/weekday_selector.dart';

class AffirmationsPage extends StatefulWidget {
  const AffirmationsPage({Key? key}) : super(key: key);

  @override
  AffirmationsState createState() => AffirmationsState();
}

class AffirmationsState extends State<AffirmationsPage> {
  List<NotificationCard> cards = [];

  @override
  void initState() {
    //adding item to list, you can add using json from network
    cards
      ..add(
        NotificationCard(
          id: '1',
          notificationTime: '11:33',
          isEnabled: false,
        ),
      )
      ..add(
        NotificationCard(
          id: '2',
          notificationTime: '19:04',
          isEnabled: false,
        ),
      )
      ..add(
        NotificationCard(
          id: '3',
          notificationTime: '03:55',
          isEnabled: false,
        ),
      )
      ..add(
        NotificationCard(
          id: '4',
          notificationTime: '12:00',
          isEnabled: true,
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
                  title: ElevatedButton(
                    child: Text(cardEntry.notificationTime),
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
                          ? cardEntry.notificationTime = '12:00'
                          : cardEntry.notificationTime =
                              '${selectedTime?.hour}:${selectedTime?.minute}';
                      //Update UI
                      setState(() {});
                    },
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        child: const Icon(Icons.delete),
                        onPressed: () {
                          /*delete action for this button
                        remove the element from list whose id matches this
                        card's id*/
                          cards.removeWhere((element) {
                            return element.id == cardEntry.id;
                          });
                          setState(() {
                            //refreshes the UI - making it match card list
                          });
                        },
                      ),
                      ToggleButtons(
                        onPressed: (int index) {
                          // All buttons are selectable.
                          setState(() {
                            cardEntry._chosenDays[index] =
                                !cardEntry._chosenDays[index];
                          });
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
                      Switch(
                        value: cardEntry.isEnabled,
                        onChanged: (value) {
                          cardEntry.isEnabled = value;
                          setState(() {});
                        },
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
        elevation: 25,
        child: const Icon(Icons.add),
        onPressed: () {
          cards.add(
            NotificationCard(
              id: '${cards.length + 1}',
              notificationTime: '00:00',
              isEnabled: true,
            ),
          );
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

  String id, notificationTime;
  bool isEnabled;
  final List<bool> _chosenDays = <bool>[
    true,
    true,
    true,
    true,
    true,
    true,
    true
  ];
}

//Global list of days of the week
//Allows quick use anywhere
const List<Widget> weekdays = <Widget>[
  Text(
    'Sun',
    style: TextStyle(fontSize: 10),
  ),
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
];
