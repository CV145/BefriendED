import 'package:befriended_flutter/app/affirmations/NotificationCard.dart';
import 'package:befriended_flutter/services/local_notification_service.dart';
import 'package:befriended_flutter/services/preferences_service.dart';
import 'package:flutter/material.dart';

class AffirmationsPage extends StatefulWidget {
  const AffirmationsPage({Key? key, required this.closeAffirmationsOnTap})
      : super(key: key);

  final Function() closeAffirmationsOnTap;

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

  Future<void> _rebuildCards() async {
    //rebuild the list of cards using saved data
    final loadedCards = _preferencesService.loadAffirmationsData();
    //then - callbacks to be called when Future completes
    await loadedCards.then((value) => cards = value);
    setState(() {
      //Update UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () {
            //Close this widget
            widget.closeAffirmationsOnTap();
            //Update UI
            setState(() {});
          },
        ),
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
                      Column(
                        children: [
                        ElevatedButton(
                          //Delete button
                          child: const Icon(Icons.delete),
                          onPressed: () {
                            /*delete action for this button
                          remove the element from list whose id matches this
                          card's id*/

                            //Cancel the notification set for this time
                            //There is only 1 notification per card
                            cardEntry.cancelNotification(_notificationsService);

                            setState(() {
                              //refreshes the UI - making it match the card list
                              cards.removeWhere((element) {
                                return element.id == cardEntry.id;
                              });

                              var i = 1;
                              //Reset the IDs of the cards
                              for (final card in cards) {
                                card.id = i;
                                i++;
                              }
                            });
                            //Save all our updated card data
                            _preferencesService.saveAffirmationsData(cards);
                          },
                        ),],
                      ),
                      Column(
                        children:
                        [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                            ElevatedButton(
                              //Time Picker button
                              child: Text(
                                cardEntry.affirmationTime.minute < 10
                                    ? '${cardEntry.affirmationTime.hour}:0${cardEntry.affirmationTime.minute}'
                                    : '${cardEntry.affirmationTime.hour}:${cardEntry.affirmationTime.minute}',
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
                                    ? cardEntry.affirmationTime =
                                const TimeOfDay(hour: 12, minute: 0)
                                    : cardEntry.affirmationTime = selectedTime;

                                if (cardEntry.isEnabled)
                                {
                                  //Schedule the notification
                                  await cardEntry.scheduleNotification(
                                    _notificationsService,
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
                                setState(() {
                                  cardEntry.isEnabled = value;
                                });

                                if (value == false) {
                                  cardEntry.cancelNotification(
                                    _notificationsService,
                                  );
                                } else {
                                  cardEntry.scheduleNotification(_notificationsService);
                                }
                                //Save all our updated card data
                                _preferencesService.saveAffirmationsData(cards);
                              },
                            ),],
                          ),
                          Row(
                            children:
                            [
                              ToggleButtons(
                                //Weekday buttons
                                onPressed: (int index) {
                                  // Switch at the given index
                                  cardEntry.chosenDays[index] =
                                  !cardEntry.chosenDays[index];



                                  //Update UI
                                  setState(() {});


                                  print(
                                      'Day pressed: $index for card #${cardEntry.id}');
                                  print('Chosen days: ${cardEntry.chosenDays}');


                                  //Save all our updated card data
                                  _preferencesService.saveAffirmationsData(cards);

                                  if (cardEntry.isEnabled)
                                  {
                                    //Schedule the notification
                                    cardEntry.scheduleNotification(
                                      _notificationsService,
                                    );
                                  }
                                },
                                borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
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
                        ],
                      ),

                    ],
                  ),
                  /*&subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [


                    ],
                  ),*/
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
            affirmationTime: const TimeOfDay(hour: 12, minute: 0),
            isEnabled: true,
          );
          cards.add(newCard);
          selectedTime == null
              ? newCard.affirmationTime = const TimeOfDay(hour: 12, minute: 0)
              : newCard.affirmationTime = selectedTime;

          setState(() {
            //UI refresh
          });

          //Schedule a notification using the new DateTime
          await newCard.scheduleNotification(_notificationsService);

          //Save all our updated card data
          await _preferencesService.saveAffirmationsData(cards);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
