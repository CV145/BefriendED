import 'dart:core';

import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/user_profile/chip_model.dart';
import 'package:befriended_flutter/app/user_profile/tag_pool.dart' as pool;
import 'package:befriended_flutter/app/user_profile/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfilePage extends StatefulWidget {
  //All widgets and elements have a unique key
  //Old widgets are replaced with new ones and keys are used to do this
  UserProfilePage({Key? key}) : super(key: key);

  final User user = User('User');

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  late pool.Tags tagPool;
  //Build a list of Chip Items by instantiating
  late List<ActionChip> topicChipsList = [];

  @override
  void initState() {
    super.initState();
    tagPool = pool.Tags(appUser: widget.user);

    //Create a action chip out of each topic
    //Selecting that chip will add it to the user profile
    topicChipsList =
        tagPool.eatingDisorderTopics.map((topic) =>
            ActionChip(
              label: Text(topic),
              autofocus: true,
              onPressed: ()
              {
                setState(() {
                  //Update UI
                  widget.user.selectedTopics.
                  add(ChipModel(id: '0', name: topic));
                  print('was selected');
                });
              },
            ),).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        widget.user.name = state.name;
        return SafeArea(
          child: Scaffold(
            body: Center(
              child: Column(
                //Horizontal Alignment
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //Vertical ("main") axis
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  getUserCardWidget(context),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      const Text('Choose your interests from the list below:'),
                      Wrap(children: topicChipsList),
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

  void deleteChip(String givenID)
  {
    setState(() {
      widget.user.selectedTopics.
      removeWhere((element) => element.id == givenID);
    });
  }

  //Return widget displaying user info on a card
  Widget getUserCardWidget(BuildContext context) {
    return Card(
      child: Column(
        children:
        [
          Container(
            //width: 80,
            //height: 80,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
              borderRadius: const BorderRadius.all(Radius.circular(100)),
            ),
            child: Text(
              widget.user.name,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge,
              textAlign: TextAlign.center ,
            ),      ),
          const Padding(padding: EdgeInsets.all(25)),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Wrap(
              children:
              widget.user.selectedTopics.map((chip) =>
              Chip(
                //Using info from ChipModel
                label: Text(chip.name),
                onDeleted: () {deleteChip(chip.id);},
              ),).toList(),
            ),
          )
        ],
      ),
    );
  }
}
