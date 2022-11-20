
import 'package:befriended_flutter/app/local_database.dart';
import 'package:befriended_flutter/app/models/chat_invite.dart';
import 'package:befriended_flutter/app/models/chip_model.dart';
import 'package:befriended_flutter/app/models/friend_model.dart';

/*
User model object, represents a profile, uploaded to Firebase
The uid is needed to reference the user's document in the database
 */
class UserModel {
  UserModel({required String firestoreUid, required String givenName,
    required String givenEmail,
    required List<String> givenTopics,}) {
    uid = firestoreUid;
    name = givenName;
    email = givenEmail;
    var i = 0;
    for (final topic in givenTopics)
      {
        final newChip = ChipModel(id: '$i', name: topic);
        selectedTopics.add(newChip);
        i++;
      }
  }

  late final String name;
  late final String email;
  late final String uid;
  List<ChipModel> selectedTopics = [];
  List<Friend> friendsList = [];
  List<ChatInvite> receivedInvites = [];
  List<ChatInvite> outgoingInvites = [];
  List<DateTime> scheduledChats = [];

  ///Updates the selected topics and stores them in the database
  List<String> storeSelectedTopics(List<ChipModel> newTopics)
  {
    selectedTopics = newTopics;
    final topicStrings = <String>[];
    for (final topic in newTopics)
    {
      topicStrings.add(topic.name);
    }
    //Update user doc
    LocalDatabase.updateUserDocument(newTopics: topicStrings);
    return topicStrings;
  }
}
