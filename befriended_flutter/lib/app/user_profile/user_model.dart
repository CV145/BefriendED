import 'package:befriended_flutter/app/support/friend_model.dart';
import 'package:befriended_flutter/app/user_profile/chip_model.dart';

/*
User model object, represents a profile, uploaded to Firebase
 */
class User {
  User({required String givenName, List<ChipModel>? topics}) {
    name = givenName;
    selectedTopics = topics ?? [];
  }

  String name = 'User';

  //Regular chips with delete property
  List<ChipModel> selectedTopics =
  [
   // ChipModel(id: '1', name: 'topic1',),
    //ChipModel(id: '2', name: 'topic2',),
   // ChipModel(id: '3', name: 'topic3',),
  ];

  //Bad O(n) structure, key-value pair might be better
  List<Friend> friendsList = [];

}
