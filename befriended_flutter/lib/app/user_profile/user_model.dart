import 'package:befriended_flutter/app/user_profile/chip_model.dart';
import 'package:flutter/material.dart';

/*
User model object, represents a profile, uploaded to Firebase
 */
class User {
  User(String givenName) {
    name = givenName;
  }

  String name = 'User';

  //Regular chips with delete property
  List<ChipModel> selectedTopics =
  [
   // ChipModel(id: '1', name: 'topic1',),
    //ChipModel(id: '2', name: 'topic2',),
   // ChipModel(id: '3', name: 'topic3',),
  ];


}
