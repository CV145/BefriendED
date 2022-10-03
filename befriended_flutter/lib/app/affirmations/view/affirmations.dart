import 'package:flutter/material.dart';

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
              return Container(
                child: Card(
                  child: ListTile(
                    title: Text(cardEntry.notificationTime),
                    trailing: ElevatedButton(
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
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

//Modal class for NotificationCard object "model"
//required keyword means variable must be initialized through constructor
class NotificationCard {
  NotificationCard({
    required this.id,
    required this.notificationTime,
    required this.isEnabled,
  });

  String id, notificationTime;
  bool isEnabled;
}
