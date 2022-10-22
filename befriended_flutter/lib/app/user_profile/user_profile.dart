import 'dart:core';

import 'package:befriended_flutter/app/user_profile/tags_pool.dart' as pool;
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  //All widgets and elements have a unique key
  //Old widgets are replaced with new ones and keys are used to do this
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  late pool.Tags tags;

  @override
  void initState() {
    super.initState();
    tags = pool.Tags();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Wrap(
                  spacing: 10,
                  children: tags.chipsList,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*
User model object, represents a profile, uploaded to Firebase
 */
class User {
  var name = '';
  var tags = List.filled(3, '', growable: false);
}
