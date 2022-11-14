import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

/*
The chat room is where chat messaging takes place.
It's a full page that is meant to be stacked up over the Home page.
It has a full app bar that shows the name of the user chatting with, their online
status, a back button, and vertical chat settings button

The body of the page lists out all the messages between both users.
The page would have to constantly read from a json file stored on the database

The bottom drawer has a text field to write in, a button for looking into the
device's images, and a send button
 */
class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  ChatRoomPageState createState() => ChatRoomPageState();
}

class ChatRoomPageState extends State<ChatRoomPage> {
  List<types.Message> _messages = [];
  final types.User _user =
  const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

  //Controller for a scrollable widget
  final ScrollController _controller = ScrollController();

  //Controller for an editable text field
  final TextEditingController _postEditingController = TextEditingController();

  String otherUserName = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        onSendPressed: (PartialText ) {  },
        user: _user,
      ),
    );
  }
}
