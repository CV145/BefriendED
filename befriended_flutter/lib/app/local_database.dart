import 'dart:async';
import 'package:befriended_flutter/app/models/chat_invite.dart';
import 'package:befriended_flutter/app/models/chat_meeting.dart';
import 'package:befriended_flutter/app/models/request_model.dart';
import 'package:befriended_flutter/app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//ctrl+f for quick searches
///To make things simpler, this class will be responsible for storing
///anything retrieved from the database using read-only getters. The only way
///to set this data is by calling the public methods that speak to the
///database.
class LocalDatabase
{
  /*Private*/

  static final _firebaseAuth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  ///We can assume requests are sorted.
  static late List<Request> _retrievedRequests = [];

  static UserModel _loggedInUser = UserModel(firestoreUid: 'null',
    givenName: 'error: no user', givenTopics: [], givenEmail: 'error',);


  static var _dateTimes = <DateTime>[];

  ///Will create and set a UserModel for the logged-in user. This model can be
  ///retrieved with getLoggedInUser(). The UserModel is filled with info
  ///obtained from the Cloud Firestore document matching the given ID.
  static Future<void> _buildLocalUser(String? firestoreID) async {
    if (firestoreID == null) {
      print('Error building user, firestore ID was null');
      throw NullThrownError();
    }
    Map<String, dynamic>? retrievedData;
    var userName = ''; var email = '';
    final chosenTopics = <String>[];
    final DocumentReference docRef =
    _firestore.collection('registered_users').doc(firestoreID);
    //Get user data, then() is called after get() completes (in the future)
    await docRef.get().then(
            (DocumentSnapshot doc) async {
          retrievedData = doc.data() as Map<String, dynamic>?;
          userName = retrievedData!['name'] as String;
          email = retrievedData!['email'] as String;
          final dynamic retrievedTopics = retrievedData!['chosenTopics'];
          for(final item in retrievedTopics) {
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
        },);
    await refreshChatInvites();
    await refreshOutgoingInvites();
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
      'chatInvites': <String, dynamic>{},
      'outgoingInvites': <dynamic> [],
      'scheduledChats': <dynamic> [],
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
      String givenPassword,) async {
    var error = "There's been an error";
    try {
      //Create new account was successful
      final credential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: givenEmail,
        password: givenPassword,);
      //Create new entry in database for the user
      final userID = credential.user?.uid;
      if (userID != null) {
        _createNewUserDocument(firestoreID: userID, name: givenName, email:
        givenEmail,);
        await _buildLocalUser(userID);
      }
      else {
        return 'Error: UID for new user was null';
      }
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
    List<String>? newTopics,}) {
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
        .set(userData, SetOptions(merge: true));
  }

  ///Get the username of the given ID sometime in the future.
  static Future<String> getUserNameFrom(String uid)
  {
    final DocumentReference document
    = _firestore.collection('registered_users').doc(uid);
    //Note: get() returns a future DocumentSnapshot which is passed into then()
    return document.get().then((DocumentSnapshot doc)
    => (doc.data() as Map?)!['name'] as String,);
  }

  static String? getRandomAffirmation() {
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

  ///Call this to get new requests from the database.(Note: just gets all the
  ///requests for now). Will return the first page of the requests using the
  ///given perPage parameter.
  static Future<List<Request>> refreshRequests(int perPage) async {
    _retrievedRequests = [];
    final CollectionReference ref =
        _firestore.collection('requests');
    //Get docs from collection ref
    final querySnapshot = await ref.get();
    //Iterate through each doc in 'requests' collection
    for(final doc in querySnapshot.docs) {
      if (doc.id == 'allRequests' || doc.id == 'null'
          || doc.id == _loggedInUser.uid) {
        continue;
      }
      final data = doc.data() as Map<String, dynamic>?;
      final id = data!['uid'] as String;
      final name = data!['username'] as String;
      //Data must be broken down from dynamic structure to literal
      final topics = data['topics'] as List<dynamic>;
      final topicStrings = <String>[];
      for (final topic in topics) {
        topicStrings.add(topic as String);
      }
      final newRequest = Request(requesterID: id, requesterName: name,
          givenTopics: topicStrings,);
      _retrievedRequests.add(newRequest);
    }
  //Need some kind of query to sort the requests
  return getRequestsPage(0, perPage);
  }

  ///Get a list of requests whose length = perPage, starting at the given
  ///pageNumber. This is basically dividing the sorted requests list stored
  ///in this class. Note: first page = 0
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

  ///Update the user's personal request in the database
  static void updatePersonalRequest(Request updatedRequest) {
    final requestData = <String, dynamic>{
      'uid': updatedRequest.userID,
      'username': updatedRequest.name,
      'topics': updatedRequest.topics,
    };
    _firestore.collection('requests')
        .doc(updatedRequest.userID)
        .set(requestData);
  }

  ///Get the total number of request pages.
  static int getNumberOfRequestPages(int perPage) {
    return _retrievedRequests.length ~/ perPage + 1;
  }

  ///This method is meant to be called periodically while the app is running.
  ///If the app isn't running, Firebase Cloud Messaging will send a notification
  ///to this user of any new invites. This method should also be called on
  ///app login-in. Will refresh the chat invites stored in the user object.
  static Future<void> refreshChatInvites() async {
    _loggedInUser.receivedInvites = [];
    final outdatedInviteSenders = <String>[];
    final DocumentReference document
    = _firestore.collection('registered_users').doc(getLoggedInUser().uid);
    await document.get().then((DocumentSnapshot doc) async {
      final data = doc.data() as Map?;
      //Iterate through each entry in chatInvites map
      final invites = data!['chatInvites'] as Map<String, dynamic>
      ..forEach((key, dynamic value) {
        final inviteMap = value as Map<String, dynamic>;
        final senderID = inviteMap['senderID'] as String;
        final fromName = inviteMap['from'] as String;
        final toName = inviteMap['to'] as String;
        final isDeclined = inviteMap['isDeclined'] as bool;
        final year = inviteMap['year'] as int;
        final month = inviteMap['month'] as int;
        final day = inviteMap['day'] as int;
        final hour = inviteMap['hour'] as int;
        final minute = inviteMap['minute'] as int;
        final newChatInvite = ChatInvite(senderID: senderID, fromName: fromName,
          toName: toName, isDeclined: isDeclined, year: year,
          month: month, day: day, hour: hour, minute: minute,);
        if (!newChatInvite.isDeclined) {
          _loggedInUser.receivedInvites.add(newChatInvite);
        } else {
          //Mark for deletion
          outdatedInviteSenders.add(senderID);
        }
      });
      //Delete the outdated invites
      final updatedChatInvites = invites;
      for(final id in outdatedInviteSenders) {
        updatedChatInvites[id].clear();
        updatedChatInvites.remove(id);
      }
      final updates = <String, dynamic> {
        'chatInvites' : updatedChatInvites
      };
      await document.update(updates);
    });
  }

  ///Delete the given chat invite from the database in the user's path
  static Future<void> deleteChatInvite(String senderID) async {
    final DocumentReference document
    = _firestore.collection('registered_users').doc(getLoggedInUser().uid);
    await document.get().then((DocumentSnapshot doc) async {
      final data = doc.data() as Map?;
      final invites = data!['chatInvites'] as Map<String, dynamic>;
      //Clear everything before removing the entry from chatInvites
      final senderInvite = invites[senderID] as Map<String, dynamic>
      ..clear();
      invites.remove(senderID);
      final updates = <String, dynamic> {
        'chatInvites' : invites
      };
      await document.update(updates);
    });
  }

  ///Grab and update outgoing invites from the database for the current user.
  static Future<void> refreshOutgoingInvites() async {
      /* Outgoing invites are stored as paths in the database that need to be
      parsed. We need to grab individual invites from these paths and fill in
      the user's outgoing ChatInvites list.*/
    _loggedInUser.outgoingInvites = [];
    final invitePaths = <String>[];
    final DocumentReference userDocument
    = _firestore.collection('registered_users').doc(getLoggedInUser().uid);
    await userDocument.get().then((DocumentSnapshot doc) async {
      final data = doc.data() as Map?;
      final outgoingInvitePaths = data!['outgoingInvites'] as List<dynamic>;
      for (final invitePath in outgoingInvitePaths) {
        final path = invitePath as String;
        invitePaths.add(path);
      }
    });
    /*
    Each path needs to be parsed so we can locate the right chat invite from
    the other users and store their data here
    Path outline: registered_users/receiverID/chatInvites/senderID

    If the invite doesn't exist or is declined, remove the path
     */
    for(final path in invitePaths) {
      final tokens = path.split('/');
      final DocumentReference foreignDocument =
      _firestore.collection('registered_users').doc(tokens[1]);
      await foreignDocument.get().then((DocumentSnapshot foreignDoc) async {
        final foreignData = foreignDoc.data() as Map?;
        final foreignInvites = foreignData!['chatInvites']
        as Map<String, dynamic>;
        final outgoingInviteMap =
        foreignInvites[_loggedInUser.uid] as Map<String, dynamic>?;
        if (outgoingInviteMap != null) {
          final senderID = outgoingInviteMap['senderID'] as String;
          final fromName = outgoingInviteMap['from'] as String;
          final toName = outgoingInviteMap['to'] as String;
          final isDeclined = outgoingInviteMap['isDeclined'] as bool;
          final year = outgoingInviteMap['year'] as int;
          final month = outgoingInviteMap['month'] as int;
          final day = outgoingInviteMap['day'] as int;
          final hour = outgoingInviteMap['hour'] as int;
          final minute = outgoingInviteMap['minute'] as int;
          final newChatInvite = ChatInvite(
            senderID: senderID,
            fromName: fromName,
            toName: toName,
            isDeclined: isDeclined,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,);
          _loggedInUser.outgoingInvites.add(newChatInvite);
        } else {
          //Delete this path from user's outgoing invites
          await userDocument.update({
            'outgoingInvites': FieldValue.arrayRemove(<String>[path]),
          });
        }
      });
    }
  }

  ///Mark an invite as declined. Declined invites are deleted from the
  ///database but stored locally and can be deleted by the user whenever they
  ///want. .... Could rename this to "writeInvite" instead
  static Future<void> declineInvite(ChatInvite invite) async {
      final updatedInvite = <String, dynamic> {
        'senderID' : invite.senderID,
        'from': invite.fromName,
        'to': invite.toName,
        'isDeclined': true,
        'year': invite.year,
        'month': invite.month,
        'day': invite.day,
        'hour': invite.hour,
        'minute': invite.minute
      };
     final updates = <String, dynamic>{
        invite.senderID: updatedInvite
    };
     final docRef =
     _firestore.collection('registered_users').doc(getLoggedInUser().uid);
     await docRef.update({'chatInvites': updates});
  }

  ///Update the DateTimes for each chat the user has scheduled.
  static Future<void> refreshScheduledChats() async {
    _loggedInUser.scheduledChats = [];
    final DocumentReference document
    = _firestore.collection('registered_users').doc(getLoggedInUser().uid);
    await document.get().then((DocumentSnapshot doc) async {
      final data = doc.data() as Map?;
      final dates = data!['scheduledChats'] as List<dynamic>;
      final updatedDates = <Map<String, dynamic>>[];
      for(final date in dates) {
        final dateMap = date as Map<String, dynamic>;
        final chattingWith = dateMap['chattingWith'] as String;
        final signalRGroup = dateMap['signalRGroup'] as String;
        final year = dateMap['year'] as int;
        final month = dateMap['month'] as int;
        final day = dateMap['day'] as int;
        final hour = dateMap['hour'] as int;
        final minute = dateMap['minute'] as int;
        final newMeeting = ChatMeeting(chattingWith,
          await LocalDatabase.getUserNameFrom(chattingWith), year,
            month, day,
            hour, minute, signalRGroup,);
        // TODO(cv145): if newDateTime is utc, convert to local time
        final newDateTime = DateTime(year, month, day, hour, minute);
        if (DateTime.now().isBefore(newDateTime.add(const Duration(minutes: 30)))) {
          _loggedInUser.scheduledChats.add(newMeeting);
          _dateTimes.add(newDateTime);
          //delete expired date time from schedule
          updatedDates.add(date);
        }
      //Sort scheduled chats
      _dateTimes.sort();
      print(_dateTimes);
      }
      //We need to overwrite the old array of chats with a new one that
      //doesn't have the expired chats
      print('Here are our updated dates: $updatedDates');
      final updates = <String, dynamic>{
        'scheduledChats': updatedDates
      };
      //Update the user document with this new field
      await document.update(updates);
    });
  }

  ///Gets next scheduled chat (refreshScheduledChats() needs to be called
  ///first)
  static String getNextScheduledChatTimeString(){
    final nextTime = _dateTimes[0];
    return '${nextTime.month}/${nextTime.day}/${nextTime.year} at ${nextTime.hour}:${nextTime.minute}';
  }

  static DateTime getNextScheduledChatTime(){
    return _dateTimes[0];
  }
}
