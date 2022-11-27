import 'dart:convert';
import 'dart:math';
import 'package:befriended_flutter/app/local_database.dart';
import 'package:befriended_flutter/app/models/chat_meeting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:signalr_netcore/msgpack_hub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:uuid/uuid.dart';

/*
The chat room works with SignalR to bring messages to the user.
 */
class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key, required this.meetingInfo}) : super(key: key);

  //Contains SignalR group name
  final ChatMeeting meetingInfo;

  @override
  ChatRoomPageState createState() => ChatRoomPageState();
}

class ChatRoomPageState extends State<ChatRoomPage> {
  List<types.Message> _messages = [];
  final types.User _user =
  types.User(id: LocalDatabase.getLoggedInUser().uid);
  late final types.User otherUser;

  late String otherUserName;

  static const chatUrl =
      'https://befriendedsignalrchatserver.azurewebsites.net/chatHub';

  ///The connection to the Hub on the SignalR Server
  static late final HubConnection chatConnection;

  @override
  void initState() {
    super.initState();
    createChatConnection();
    otherUserName = widget.meetingInfo.chattingWithName;
    otherUser = types.User(id: widget.meetingInfo.chattingWithID);
    //_loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Row(
          children: [
            Text(otherUserName),
            //Online status indicator goes here
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () { Navigator.pop(context);},
        ),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        showUserAvatars: true,
        showUserNames: true,
        user: _user,
      ),
    );
  }

   Future<void> createChatConnection() async {
    chatConnection = HubConnectionBuilder().withUrl(chatUrl)
    /*Configure the Hub with msgpack protocol*/
        .withHubProtocol(MessagePackHubProtocol())
        .withAutomaticReconnect()
        .build();
    chatConnection.onclose( ({Exception? error}) => print('Connection Closed'));
    await chatConnection.start()?.then((void f){
      print('Connection to chat host established');
      chatConnection.on('receiveMessage', receiveMessage);
      joinSignalRGroup();
    });
  }

  //Join the group contained inside the ChatMeeting object. Will
  //add this connection to the group.
  Future<void> joinSignalRGroup() async {
      final result = await chatConnection.invoke('AddToGroup', args:
      <Object>[widget.meetingInfo.signalRGroupName],);
      print(result);
  }

  //Receive a text message from the other user. Called by server, which is
  //called by client when calling sendMessage()
  void receiveMessage(List<Object?>? paramsList){
    print('Server invoked receiveMessage()');
    var senderName = paramsList?[0] as String;
    final msgText = paramsList?[1] as String;
    print('Message received: $msgText from $senderName');
    final newTxtMsg = types.TextMessage(
      author: otherUser,
      id: randomString(),
      text: msgText,
    );
    _addMessage(newTxtMsg);
  }

  //Send a text message to the server
  Future<void> sendMessage(String messageTxt) async {
    final result = await chatConnection.invoke('SendMessage', args:
    <Object>[LocalDatabase.getLoggedInUser().name, messageTxt,
      widget.meetingInfo.signalRGroupName],);
    print(result);
  }

  /*
  We need to join a group where the other user is in through SignalR
  Then we need to receive messages from that group anytime there is an update
  There need to be methods that are called from the server
   */

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
    sendMessage(textMessage.text);
  }

  /*
  Future<void> _loadMessages()  async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((dynamic e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

   /*final result = await SignalRClient.invokeSimpleFunction();

    final newMsg = types.TextMessage(
        author: _user,
        id: '0',
        text: result ?? 'Server message did not load',); */

    //messages.insert(0, newMsg);

    setState(() {
      _messages = messages;
    });
  }*/

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }
}
