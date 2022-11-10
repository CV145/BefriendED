import 'dart:core';

import 'package:befriended_flutter/app/local_database.dart';
import 'package:befriended_flutter/app/models/chip_model.dart';
import 'package:befriended_flutter/app/models/tag_pool.dart' as pool;
import 'package:befriended_flutter/app/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  //All widgets and elements have a unique key
  //Old widgets are replaced with new ones and keys are used to do this
  UserProfilePage({Key? key}) : super(key: key);

  //User has been passed in through constructor
  final UserModel user = LocalDatabase.getLoggedInUser();

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  late pool.Tags tagPool;
  //Build a list of Chip Items by instantiating
  late List<ElevatedButton> topicsList = [];

  @override
  void initState() {
    super.initState();
    tagPool = pool.Tags(appUser: widget.user);

    //Create a action chip out of each topic
    //Selecting that chip will add it to the user profile
    topicsList =
        tagPool.eatingDisorderTopics.map((topic) =>
            ElevatedButton(
              child: Text(topic),
              onPressed: ()
              {
                final selectedTopics = widget.user.selectedTopics;

                final numSelected = selectedTopics.length;

                if (numSelected< 3 &&
                    selectedTopics.
                    singleWhere((model) => model.name == topic,
                    orElse: () => ChipModel(id: '99', name: 'null'),).name
                        == 'null') {
                  setState(() {
                    //Update UI
                    selectedTopics.
                    add(ChipModel(
                      id: (numSelected+1).toString(),
                      name: topic,),);

                    widget.user.storeSelectedTopics(selectedTopics);
                  });
                }
              },
            ),).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
            body: Center(
              child: Column(
                //Horizontal Alignment
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //Vertical ("main") axis
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:const [
                      Icon(Icons.arrow_downward),
                      Icon(Icons.arrow_downward),
                      Icon(Icons.arrow_downward),],
                  ),
                  getUserCardWidget(context),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      const Text('Choose your interests from the list below:'),
                      Wrap(children: topicsList),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
  }

  void deleteChip(String givenID)
  {
    setState(() {
      final userTopics = widget.user.selectedTopics
      ..removeWhere((element)
      => element.id == givenID,);

      widget.user.storeSelectedTopics(userTopics);
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
          const Padding(
              padding: EdgeInsets.all(15),
              child: Text('- Your Topics -'),),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Wrap(
              children:
              //Map the user's topics into Chip widgets
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
