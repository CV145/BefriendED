import 'package:befriended_flutter/app/support/chat/chat_message.dart';
import 'package:befriended_flutter/app/user_profile/user_global_state.dart';
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:befriended_flutter/firebase/firestore_provider.dart';


/*
This class is responsible for making and returning ChatMessage lists from DB
using given data

Chat messages between 2 users are stored in a json list. The database can
store just the latest message from a chat, and local storage/shared prefs
can keep a .json file of all the messages so far. This .json file could
be backed up just like with whatsapp.

Keeping just 1 message on the server can save a lot of space and reduce
retrieval time.

A chat between two users can be identified using their user IDs, delimited
with '_'

Ex: chats/uid1_uid2/"latestMessage" : msgObj

The key is to pinpoint and set where exactly to get data from every time
 */
class ChatMessageClient
{
  ChatMessageClient(this.otherID)
  {
    final senderID = UserGlobalState.loggedInUser.uid;

    final possiblePaths =
    <String>[
      'chats/${senderID}_$otherID',
      'chats/${otherID}_$senderID',
    ];

    for (final possiblePath in possiblePaths)
    {
      chatData =  firebase.getJsonObjFrom(possiblePath) as Map<String, Object>?;

      //Does the chat exist at the possible path?
      if (chatData != null)
      {
        //Chat data path found
        path = possiblePath;
        return;
      }
      else
      {
        print('Warning: no chat history exists between $senderID and $otherID');
      }
    }
  }

  //To find the valid chat path in the DB, it must contain both uid1 and uid2
  late final String path;
  final firebase = FirebaseProvider();
  final firestore = FirestoreProvider();
  late final Map<String, Object>? chatData;
  late final String otherID;

  //Gets the latest message using the path found in the constructor
  ChatMessage? getLatestMessage()
  {
    final latestMsgPath = '$path/latestMessage';
    final msgMap = firebase.getJsonObjFrom(latestMsgPath)
    as Map<String, Object>?;

    if (msgMap != null) {
      final sender = msgMap['sender'] as String?;
      final msg = msgMap['msg'] as String?;
      final timestamp = msgMap['timestamp'] as String?;

      // TODO(cv145): set the dateTime.
      return ChatMessage(msg ?? 'error: no msg', sender ?? 'error: no sender',
          DateTime(2022, 11, 5),);
    }
    else
    {
      return null;
    }
  }

  //Send a message to the user ID established in the constructor
  void sendNewMessage(String msg)
  {
    // TODO(cv145): add timestamps.
    final msgMap = <String, Object>{
      'sender' : UserGlobalState.loggedInUser.name,
      'msg' : msg,
    };

    firebase.setJsonData(path, msgMap);
  }

  //Get the name of the given user ID
  Future<String> getUserNameFrom(String uid)
  {
    return firestore.getUserNameFrom(uid);
  }
}
