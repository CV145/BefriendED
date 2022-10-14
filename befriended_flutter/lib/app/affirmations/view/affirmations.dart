import 'package:befriended_flutter/app/affirmations/NotificationCard.dart';
import 'package:befriended_flutter/services/local_notification_service.dart';
import 'package:befriended_flutter/services/preferences_service.dart';
import 'package:flutter/material.dart';


class AffirmationsPage extends StatefulWidget {
  const AffirmationsPage({Key? key}) : super(key: key);

  @override
  AffirmationsState createState() => AffirmationsState();
}



class AffirmationsState extends State<AffirmationsPage> {
  List<NotificationCard> cards = [];
  late final LocalNotificationService _notificationsService;
  final _preferencesService = PreferencesService();

  @override
  void initState() {
    //initialize the service
    _notificationsService = LocalNotificationService();
    _notificationsService.initialize();

    _rebuildCards();
    super.initState();
    }

    void _rebuildCards() async
    {
      //rebuild the list of cards using saved data
      final loadedCards = _preferencesService.loadAffirmationsData();
      //then - callbacks to be called when Future completes
      await loadedCards.then((value) => cards = value);
      setState(() {
        //Update UI
      });
    }

  @override
  Widget build(BuildContext context)  {
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
                        //Issue: If the time picker picks a time within the same hour
                        //it will not set a notification
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
                              _notificationsService,
                              nextDate,
                            );
                          }



                          //Update UI
                          setState(() {});

                          //Save all our updated card data
                          await _preferencesService.saveAffirmationsData(cards);
                        },
                      ),
                      Switch(
                        //Enable button
                        value: cardEntry.isEnabled,
                        onChanged: (value) {
                          cardEntry.isEnabled = value;

                          setState(() {});
                          //Save all our updated card data
                          _preferencesService.saveAffirmationsData(cards);
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


                          setState(() {
                            //refreshes the UI - making it match the card list
                            cards.removeWhere((element) {
                              return element.id == cardEntry.id;
                            });

                            var i = 1;

                            //The ID of each subsequent card must change
                            for(NotificationCard card in cards)
                            {
                                card.id = i;
                                i++;
                            }

                          });
                          //Save all our updated card data
                          _preferencesService.saveAffirmationsData(cards);
                        },
                      ),
                      ToggleButtons(
                        //Weekday buttons
                        onPressed: (int index) {
                          // Switch at the given index
                          cardEntry.chosenDays[index] =
                          !cardEntry.chosenDays[index];

                          print(cardEntry.chosenDays);

                          final nextDate = cardEntry.getNextDateTime();

                          //Update the next notification's DateTime
                          if (nextDate != null) {
                            cardEntry.setupNotification(_notificationsService,
                                nextDate,);
                          }

                          //Save all our updated card data
                          _preferencesService.saveAffirmationsData(cards);

                          setState(() {

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
                        isSelected: cardEntry.chosenDays,
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
            await newCard.setupNotification(_notificationsService, nextDate);
          }



          setState(() {
            //UI refresh
            //Because the list may exist in code but won't show unless updated

            //The built ListView keeps being deleted when I move tabs
            //Notifications appear to be showing at scheduled times
          });

          //Save all our updated card data
          await _preferencesService.saveAffirmationsData(cards);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

