import 'package:befriended_flutter/app/support/friend_model.dart';
import 'package:befriended_flutter/app/user_profile/chip_model.dart';
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*
User model object, represents a profile, uploaded to Firebase
The uid is needed to reference the user's document in the database
 */
class User {
  User({required String givenName, required String firestoreUid,
    List<ChipModel>? topics,}) {
    name = givenName;
    _selectedTopics = topics ?? [];
    uid = firestoreUid;
    final db = provider.firebaseFirestore;
    userDocRef = db.collection('registered_users').doc(uid);
  }

  String name = 'User';
  late final String uid;
  //Collection -> Document -> Data
  FirebaseProvider provider = FirebaseProvider();
  late final DocumentReference userDocRef;

  //Regular chips with delete property
  List<ChipModel> _selectedTopics = [];

  //Bad O(n) structure, key-value pair might be better
  List<Friend> friendsList = [];


  /*
  Updates the selected topics and passes them to the database
   */
  void updateSelectedTopics(List<ChipModel> newTopics)
  {
    _selectedTopics = newTopics;
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
    return _selectedTopics;
  }
}
