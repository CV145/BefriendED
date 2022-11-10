import 'package:befriended_flutter/app/models/user_global_state.dart';
import 'package:befriended_flutter/app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/*
 Cloud Firestore
 Collections -> Documents -> Data
 */
class FirestoreProvider with ChangeNotifier {
  factory FirestoreProvider() {
    return _singleton;
  }

  FirestoreProvider._internal();

  static final FirestoreProvider _singleton = FirestoreProvider._internal();

  final firebaseAuth = FirebaseAuth.instance;
  String? verificationId;
  ConfirmationResult? confirmationResult;
  final db = FirebaseFirestore.instance;

  bool isLoggedIn() {
    return firebaseAuth.currentUser?.uid != null;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  String? getCurrentUserId() {
    final user = firebaseAuth.currentUser;
    return user?.uid;
  }

  //Build and store a user model using data from firebase with the given ID
  Future<void> updateGlobalUser(String? firestoreID)
  async {
    if (firestoreID == null)
      {
        print('Error building user, firestore ID was null');
        throw NullThrownError();
      }

    Map<String, dynamic>? retrievedData;
    var userName = '';
    final chosenTopics = <String>[];

    //Initialize cloud firestore database reference
    final DocumentReference docRef =
    db.collection('registered_users').doc(firestoreID);

    //Get user data, then() is called after get() completes (in the future)
    await docRef.get().then(
          (DocumentSnapshot doc)
      async {
        retrievedData = doc.data() as Map<String, dynamic>?;

        //Populate fields
        userName = retrievedData!['name'] as String;

        //List<dynamic> being retrieved instead of List<String>
        final dynamic retrievedTopics = retrievedData!['chosenTopics'];

        for(final item in retrievedTopics)
        {
          final topic = item as String;
          chosenTopics.add(topic);
        }

        //Create new user object
        final newUser = UserModel(
          firestoreUid: firestoreID,
          givenName: userName,
          givenTopics: chosenTopics,
        );

        UserGlobalState.loggedInUser = newUser;
        //Subscribe to FCM topic = user ID
        await FirebaseMessaging.instance
            .subscribeToTopic(UserGlobalState.loggedInUser.uid);
        print('Global user updated');
        print('Firebase Messaging subscribed to topic '
            '${UserGlobalState.loggedInUser.uid}');
      },
    );


  }

  String? getRandomQuote() {
    //Initialize cloud firestore database reference
    final DocumentReference docRef
    = db.collection('affirmation_quotes').doc('quote1');

    // Key: "quote" , Value: contents of quote
    late Map? quoteData;
    String? retrievedQuote;

    //Get the quotes stored in the document
    docRef.get().then(
          (DocumentSnapshot doc)
      {
        quoteData = doc.data() as Map?;
        retrievedQuote = quoteData!['quote'] as String;
      },
    );

    return retrievedQuote;
  }

  void setUserDBData({required String firestoreID, required String name,
    required String email,})
  {
    final userData = <String, dynamic>{
      'uid': firestoreID,
      'name': name,
      'chosenTopics': <String>[],
      'email': email,
    };


    //Set to document equal to uid
    db.collection('registered_users')
        .doc(firestoreID)
        .set(userData);
  }

  //Get the username of the given ID sometime in the future
  Future<String> getUserNameFrom(String uid)
  {
    //Initialize cloud firestore database reference
    final DocumentReference document
    = db.collection('registered_users').doc(uid);

    //Note: get() returns a future DocumentSnapshot which is passed into then()
    return document.get().then((DocumentSnapshot doc)
    => (doc.data() as Map?)!['name'] as String,);
  }
}


