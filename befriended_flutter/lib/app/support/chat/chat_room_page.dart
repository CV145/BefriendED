import 'package:befriended_flutter/app/support/chat/chat_message.dart';
import 'package:befriended_flutter/app/support/chat/chat_message_client.dart';
import 'package:flutter/material.dart';

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
  const ChatRoomPage({Key? key, required this.closeOnTap,
    required this.otherID,}) : super(key: key);

  final Function() closeOnTap;
  final String otherID;

  @override
  ChatRoomPageState createState() => ChatRoomPageState();
}

class ChatRoomPageState extends State<ChatRoomPage> {

  /*
   The firebase server is only going to store the latest message from a
   conversation -but- a json file stored locally will contain chat histories
   */
  List<ChatMessage> messages = [];

  //Client responsible for getting/sending messages to another user
  late final ChatMessageClient client;

  //Controller for a scrollable widget
  final ScrollController _controller = ScrollController();

  //Controller for an editable text field
  final TextEditingController _postEditingController = TextEditingController();

  String otherUserName = '';

  @override
  void initState() {
    super.initState();

    print('Initializing chat room page');

    client = ChatMessageClient(widget.otherID);

    print('Chat client was setup');
    print('Speaking to: $otherUserName');
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
          onPressed: () {},
        ),
      ),
      //drawer: AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: messages.map((message) {
                    //Map ChatMessage objects into widgets
                    return ListTile();
                  }).toList(),
                ),
              ),
            ),
          ),
          Container(
            child: Row(
                //Bottom bar
                ),
          ),
        ],
      ),
    );
  }
}
