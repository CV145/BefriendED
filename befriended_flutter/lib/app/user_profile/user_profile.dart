import 'dart:core';

import 'package:befriended_flutter/app/user_profile/tags_pool.dart' as pool;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_cubit/app_cubit.dart';

class UserProfilePage extends StatefulWidget {
  //All widgets and elements have a unique key
  //Old widgets are replaced with new ones and keys are used to do this
  UserProfilePage({Key? key}) : super(key: key);

  final user = User('Carlos');

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  late pool.Tags tagPool;

  @override
  void initState() {
    super.initState();
    tagPool = pool.Tags();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Center(
              child: Column(
                //Horizontal Alignment
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //Vertical ("main") axis
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  widget.user.getUserCardWidget(context),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      const Text('Choose your interests from the list below:'),
                      Wrap(children: tagPool.chipsList),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/*
User model object, represents a profile, uploaded to Firebase
 */
class User {
  User(String givenName) {
    name = givenName;
  }

  String name = 'User';
  List<FilterChip> tags = [];

  //Return widget displaying user info on a card
  Widget getUserCardWidget(BuildContext context) {
    return Card(
      child: Container(
        //width: 80,
        //height: 80,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        child: Text(
          name,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
