import 'package:befriended_flutter/app/models/chat_invite.dart';
import 'package:befriended_flutter/app/models/request_model.dart';
import 'package:befriended_flutter/app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

///To make things simpler, this class will be responsible for storing
///anything retrieved from the database using read-only getters. The only way
///to set this data is by calling the update methods that speak to the
///database.
class LocalDatabase
{
  /*Private*/

  static final _firebaseAuth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  ///We can assume requests will be sorted.
  static late List<Request> _retrievedRequests;

  static late List<ChatInvite> _retrievedChatInvites;

  static UserModel _loggedInUser = UserModel(firestoreUid: 'null',
    givenName: 'error: no user', givenTopics: [], givenEmail: 'error',);


  ///Will create and set a UserModel for the logged-in user. This model can be
  ///retrieved with getLoggedInUser(). The UserModel is filled with info
  ///obtained from the Cloud Firestore document matching the given ID.
  static Future<void> _buildLocalUser(String? firestoreID) async {
    if (firestoreID == null)
    {
      print('Error building user, firestore ID was null');
      throw NullThrownError();
    }

    Map<String, dynamic>? retrievedData;
    var userName = '';
    var email = '';
    final chosenTopics = <String>[];

    //Initialize cloud firestore database reference
    final DocumentReference docRef =
    _firestore.collection('registered_users').doc(firestoreID);

    //Get user data, then() is called after get() completes (in the future)
    await docRef.get().then(
            (DocumentSnapshot doc)
        async {
          retrievedData = doc.data() as Map<String, dynamic>?;

          //Populate fields
          userName = retrievedData!['name'] as String;
          email = retrievedData!['email'] as String;

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
            givenEmail: email,
          );

          _loggedInUser = newUser;


          //Subscribe to FCM topic = user ID
          await FirebaseMessaging.instance
              .subscribeToTopic(getLoggedInUser().uid);
          print('Global user updated');
          print('Firebase Messaging subscribed to topic '
              '${getLoggedInUser().uid}');
        },);
  }



  ///Create a brand new document in the database, identified with the given ID.
  static void _createNewUserDocument({ required String firestoreID,
    required String name, required String email,}) {
    final userData = <String, dynamic>{
      'uid': firestoreID,
      'name': name,
      'email': email,
      'chosenTopics': <String> [],
      'friendsList': <String> [],
    };


    //Create or overwrite the document equal to uid
    _firestore.collection('registered_users')
        .doc(firestoreID)
        .set(userData);
  }


  /*Public*/

  ///Get the user that's signed in.
  static UserModel getLoggedInUser() {
    return _loggedInUser;
  }

  ///Create a new account and return the new user ID or an error.
  static Future<String?> createNewAccount(String givenName, String givenEmail,
      String givenPassword,)
  async {
    var error = "There's been an error";
    try {
      //Create new account was successful
      final credential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: givenEmail,
        password: givenPassword,);

      //Create new entry in database for the user
      final userID = credential.user?.uid;
      if (userID != null)
      {
        _createNewUserDocument(firestoreID: userID, name: givenName, email:
        givenEmail,);
        await _buildLocalUser(userID);
      }
      else
      {
        return 'Error: UID for new user was null';
      }

      //Subscribe to FCM topic = user ID

      return userID;
    }
    on FirebaseAuthException catch(e) {
      //Error creating new account
      error = e.code;

      if (e.code == 'weak-password') {
        error = 'error: The password provided is too weak';
      }
      else if (e.code == 'email-already-in-use') {
        error = 'error: An account already exists for that email';
      }
    }
    return error;
  }

  ///Sign in and update local user
  static Future<String?> signIn(String givenEmail, String givenPassword)
  async {

    var error = 'error signing in';

    try {
      //Login successful - update global user instance
      final credential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: givenEmail,
        password: givenPassword,);
      final userID = credential.user?.uid;
      print('Sign in successful');
      await _buildLocalUser(userID);
      print('Newly built user: ${LocalDatabase.getLoggedInUser().name}');
      return userID;
    }
    on FirebaseAuthException catch(e)
    {
      //Login failed
      if (e.code == 'user-not-found') {
        error = 'error: No user found for that email';
      } else if (e.code == 'wrong-password') {
        error = 'error: Wrong password provided for that user';
      }
    }
    return error;
  }

  static bool isLoggedIn() {
    return _firebaseAuth.currentUser?.uid != null;
  }

  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  static String? getCurrentUserId() {
    final user = _firebaseAuth.currentUser;
    return user?.uid;
  }

  ///Will store user data into the Cloud Firestore path, where document = ID of
  ///currently signed in user. Any optional data not passed in will not be
  ///updated in the database.
  static void updateUserDocument({String? newName, String? newEmail,
    List<String>? newTopics,})
  {
    final user = getLoggedInUser();

    final userData = <String, dynamic>{
      'uid': user.uid,
      'name': newName ?? user.name,
      'email': newEmail ?? user.email,
      'chosenTopics': newTopics ?? user.selectedTopics,
    };


    //Create or overwrite the document equal to uid
    _firestore.collection('registered_users')
        .doc(user.uid)
        .set(userData);
  }

  ///Get the username of the given ID sometime in the future.
  static Future<String> getUserNameFrom(String uid)
  {
    //Initialize cloud firestore database reference
    final DocumentReference document
    = _firestore.collection('registered_users').doc(uid);

    //Note: get() returns a future DocumentSnapshot which is passed into then()
    return document.get().then((DocumentSnapshot doc)
    => (doc.data() as Map?)!['name'] as String,);
  }

  static String? getRandomAffirmation() {
    //Initialize cloud firestore database reference
    final DocumentReference docRef
    = _firestore.collection('affirmation_quotes').doc('quote1');

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

  ///Call this to get new requests from the database.
  static void refreshRequests() {
    final DocumentReference docRef
    = _firestore.collection('requests').doc('allRequests');
    docRef.get().then((DocumentSnapshot doc) {
      final requests = doc.data() as List<Map>?;
      if (requests != null) {
        for (final request in requests) {
          final id = request['uid'] as String;
          final name = request['userName'] as String;
          final topics = request['topics'] as List<String>;
          final newRequest = Request(requesterID: id, givenTopics: topics,
          requesterName: name,);
          _retrievedRequests.add(newRequest);
        }
      }
    });
  }

  ///Get a list of requests whose length = perPage, starting at the given
  ///pageNumber. This is basically dividing the sorted requests list stored
  ///in this class.
  static List<Request> getRequestsPage(int pageNumber, int perPage) {
    //New page starts in intervals of perPage
    final startIndex = pageNumber * perPage;

    final requestsPage = <Request>[];

    for(var i = 0; i < perPage; i++) {
      try {
        requestsPage.add(_retrievedRequests[startIndex + i]);
      }
      catch (argumentOutOfRangeException) {
        break;
      }
    }

    return requestsPage;
  }

  ///Get the total number of request pages.
  static int getNumberOfRequestPages(int perPage) {
    return _retrievedRequests.length ~/ perPage + 1;
  }

  ///This method is meant to be called periodically while the app is running.
  ///If the app isn't running, Firebase Cloud Messaging will send a notification
  ///to this user of any new invites. This method should also be called on
  ///app login-in.
  static void refreshChatInvites() {
    final DocumentReference document
    = _firestore.collection('registered_users').doc(getLoggedInUser().uid);

    document.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map?;
      final invites = data!['chatInvites'] as List<Map>;

      String chatID;
      String from;
      String to;
      bool isActive;

      for(final invite in invites) {
        chatID = invite['chatID'] as String;
        from = invite['from'] as String;
        to = invite['to'] as String;
        isActive = invite['isActive'] as bool;
        final newChatInvite = ChatInvite(chatID: chatID, from: from,
        to: to, isActive: isActive,);
        _retrievedChatInvites.add(newChatInvite);
      }
    });

  }

  static List<ChatInvite> getChatInvites() {
    return _retrievedChatInvites;
  }

  ///Send an invite to chat to the given firebase user ID. This invite will be
  ///sent to the server, which will update the database from there and send
  ///a notification to the target user.
  static void sendInvite(String firebaseUserID, ChatInvite invite) {
    //HTTP POST to web server
    //Web server will update firestore path for given ID
    //Web server will send a notification to that user with FCM
  }
}
