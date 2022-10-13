import 'package:befriended_flutter/app/affirmations/NotificationCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
SharedPreferences are used to save data between sessions
 */
class PreferencesService {
  /*
  Saving data for all notification cards and the info stored in them
   */
  Future<void> saveAffirmationsData(List<NotificationCard> cards) async {
    final prefs = await SharedPreferences.getInstance();

    /*
    For each card in the list of cards...
    - Create a unique string key for each of them
    - Save data for each card using that string key
     */

    for (final card in cards) {
      final cardKey = 'card${card.id.toString()}';
      await prefs.setInt('${cardKey}hour', card.notificationTime.hour);
      await prefs.setInt('${cardKey}minute', card.notificationTime.minute);
      await prefs.setBool('${cardKey}isEnabled', card.isEnabled);
      final activeDays = <String>[
        't',
        't',
        't',
        't',
        't',
        't',
        't',
      ];
      /*
      For each string in the days list, cross reference with chosenDays
       */
      var i = 0;
      for (var day in activeDays) {
        if (card.chosenDays[i]) {
          day = 't';
        } else {
          day = 'f';
        }

        i++;
      }
      await prefs.setStringList('${cardKey}chosenDays', activeDays);
    }
    await prefs.setInt('numOfCards', cards.length);
  }

  //Using saved data, rebuild the list of cards
  Future<List<NotificationCard>> loadAffirmationsData()
  async {
    final prefs = await SharedPreferences.getInstance();
    var cards = <NotificationCard>[];
    final numOfCards = prefs.getInt('numOfCards') ?? 0;

    for (var i=0; i < numOfCards; i++)
    {
      final cardKey = 'card$i';
      final hour = prefs.getInt('${cardKey}hour') ?? 12;
      final minute = prefs.getInt('${cardKey}minute') ?? 00;
      final isEnabled = prefs.getBool('${cardKey}isEnabled') ?? true;
      final activeDays = prefs.getStringList('${cardKey}chosenDays');

      final newCard = NotificationCard(id: i,
          notificationTime: TimeOfDay(hour: hour,minute: minute), isEnabled: isEnabled);

      cards.add(newCard);
    }

    return cards;
  }
}
