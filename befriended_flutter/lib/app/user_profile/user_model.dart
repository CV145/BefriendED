import 'package:befriended_flutter/app/support/friend_model.dart';
import 'package:befriended_flutter/app/user_profile/chip_model.dart';
import 'package:befriended_flutter/firebase/firestore_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*
User model object, represents a profile, uploaded to Firebase
The uid is needed to reference the user's document in the database
 */
class UserModel {
  UserModel({required String firestoreUid, required String givenName,
    required List<String> givenTopics,}) {
    uid = firestoreUid;
    final db = provider.db;
    userDocRef = db.collection('registered_users').doc(uid);
    name = givenName;

    var i = 0;
    for (final topic in givenTopics)
      {
        final newChip = ChipModel(id: '$i', name: topic);
        selectedTopics.add(newChip);
        i++;
      }
  }

  late final String name;
  late final String uid;
  //Collection -> Document -> Data
  FirestoreProvider provider = FirestoreProvider();
  late final DocumentReference userDocRef;

  //Regular chips with delete property
  List<ChipModel> selectedTopics = [];

  //Store names of friends and people chatting with here
  List<String> friendsList = [];

  List<String> chattingWith = [];

  /*
  Updates the selected topics and passes them to the database
   */
  void updateSelectedTopics(List<ChipModel> newTopics)
  {
    selectedTopics = newTopics;
    final topicStrings = <String>[];

    for (final topic in newTopics)
    {
      topicStrings.add(topic.name);
    }

    //Update user doc's 'chosenTopics' data
    userDocRef.update({'chosenTopics':topicStrings});
  }


  List<ChipModel> getSelectedTopics()
  {
    return selectedTopics;
  }
}
