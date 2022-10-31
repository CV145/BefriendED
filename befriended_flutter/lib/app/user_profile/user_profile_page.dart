import 'dart:core';

import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/user_profile/chip_model.dart';
import 'package:befriended_flutter/app/user_profile/tag_pool.dart' as pool;
import 'package:befriended_flutter/app/user_profile/user_model.dart';
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfilePage extends StatefulWidget {
  //All widgets and elements have a unique key
  //Old widgets are replaced with new ones and keys are used to do this
  const UserProfilePage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  late pool.Tags tagPool;
  //Build a list of Chip Items by instantiating
  late List<ElevatedButton> topicsList = [];

  //Collection -> Document -> Data
  FirebaseProvider provider = FirebaseProvider();
  late final DocumentReference docRef;

  // Key: "quote" , Value: contents of quote
  late Map? quoteData;
  String quote = 'Be positive!';

  @override
  void initState() {
    super.initState();
    tagPool = pool.Tags(appUser: widget.user);

    //Initialize cloud firestore database reference
    final db = provider.firebaseFirestore;
    docRef = db.collection('affirmation_quotes').doc('quote1');

    //Get the quotes stored in the document
    docRef.get().then(
          (DocumentSnapshot doc)
      {
        quoteData = doc.data() as Map;
        quote = quoteData!['quote'] as String;
      },
      //onError: () => print('error'),
    );

    //Create a action chip out of each topic
    //Selecting that chip will add it to the user profile
    topicsList =
        tagPool.eatingDisorderTopics.map((topic) =>
            ElevatedButton(
              child: Text(topic),
              onPressed: ()
              {
                final selectedTopics = widget.user.getSelectedTopics();

                final numSelected = selectedTopics.length;

                if (numSelected < 3 &&
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

                    widget.user.updateSelectedTopics(selectedTopics);
                  });

                  //
                }

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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:const [
                      Icon(Icons.arrow_downward),
                      Icon(Icons.arrow_downward),
                      Icon(Icons.arrow_downward),],
                  ),
                  Text(quote, textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),),
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
      },
    );
  }

  void deleteChip(String givenID)
  {
    setState(() {
      final userTopics = widget.user.getSelectedTopics();

      userTopics.removeWhere((element)
      => element.id == givenID,);

      widget.user.updateSelectedTopics(userTopics);
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
              widget.user.getSelectedTopics().map((chip) =>
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
