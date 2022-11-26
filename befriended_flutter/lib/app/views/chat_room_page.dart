import 'dart:convert';

import 'package:befriended_flutter/app/signalr_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';

/*
The chat room works with SignalR to bring messages to the user.
 */
class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key, required this.otherUserID}) : super(key: key);

  final String otherUserID;

  @override
  ChatRoomPageState createState() => ChatRoomPageState();
}

class ChatRoomPageState extends State<ChatRoomPage> {
  List<types.Message> _messages = [];
  final types.User _user =
  const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

  String otherUserName = '';

  @override
  void initState() {
    super.initState();
    _loadMessages();
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
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.settings_sharp),
              onPressed: () {},
            )
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
  }

  Future<void> _loadMessages()  async {
    //await SignalRClient.createConnection();
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
  }
}
