import 'package:befriended_flutter/app/user_profile/user_global_state.dart';
import 'package:befriended_flutter/app/user_profile/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/*
Anything that talks directly to Firebase goes here
 */
class FirebaseProvider with ChangeNotifier {
  factory FirebaseProvider() {
    return _singleton;
  }

  FirebaseProvider._internal();

  static final FirebaseProvider _singleton = FirebaseProvider._internal();

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

  //Build and return a user using data from firebase with the given ID
  void updateGlobalUser(String? firestoreID)
  {
    if (firestoreID == null)
      {
        print('Error building user, firestore ID was null');
        throw NullThrownError();
      }

    Map<String, dynamic>? retrievedData;
    var userName = '';
    var chosenTopics = <String>[];

    //Initialize cloud firestore database reference
    final DocumentReference docRef =
    db.collection('registered_users').doc(firestoreID);

    //Get user data, then() is called after get() completes (in the future)
    docRef.get().then(
          (DocumentSnapshot doc)
      {
        retrievedData = doc.data() as Map<String, dynamic>?;

        //Populate fields
        userName = retrievedData!['name'] as String;
        //chosenTopics = retrievedData!['chosenTopics'] as List<String>;

        //Create new user object
        final newUser = UserModel(
          firestoreUid: firestoreID,
          givenName: userName,
          givenTopics: chosenTopics,
        );

        UserGlobalState.currentUser = newUser;
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
}


