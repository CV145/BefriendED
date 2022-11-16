import 'package:befriended_flutter/app/local_database.dart';
import 'package:befriended_flutter/app/models/friend_model.dart';
import 'package:befriended_flutter/app/models/request_model.dart';
import 'package:befriended_flutter/app/views/chat_room_page.dart';
import 'package:befriended_flutter/app/views/widget/bouncing_button.dart';
import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({
    Key? key,
  }) : super(key: key);

  @override
  SupportPageState createState() => SupportPageState();
}

class SupportPageState extends State<SupportPage> {
  List<Request> pageOfRequests = [];
  List<Friend> friendsList = [];

  @override
  void initState() {
    rebuildRequests();
    super.initState();
  }

  Future<void> rebuildRequests() async {
    final loadedRequests = LocalDatabase.refreshRequests(10);
    await loadedRequests.then((value) => pageOfRequests = value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _buildSupportPage(context);
  }

  Widget _buildSupportPage(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            height: 30,
            padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
            margin: const EdgeInsetsDirectional.fromSTEB(30, 50, 30, 0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: const BorderRadius.all(Radius.circular(40)),
            ),
            child: TabBar(
              labelColor: Theme.of(context).colorScheme.onPrimary,
              labelStyle: Theme.of(context).textTheme.titleSmall,
              unselectedLabelColor: Theme.of(context).colorScheme.secondary,
              unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
              indicatorColor: Colors.transparent,
              indicator: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(25),
              ),
              tabs: const [
                Tab(
                  child: Text('Requests'),
                ),
                Tab(
                  child: Text('Chat Invites'),
                ),
                Tab(
                  child: Text('Friends'),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _requestsList(pageOfRequests),
                _chatInviteList(),
                _friendsList(friendsList),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //The following returns ListViews using the given lists
  Widget _chatInviteList() {
    return BouncingButton(
      label: 'Enter Chat Room',
      onPress: () {
        setState(() {navigateToChatRoomPage(context: context);});
      },
    );
  }

  void navigateToChatRoomPage({
    required BuildContext context,
  })  {
    //Navigate to chat room page
     Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (context) => const ChatRoomPage(),
      ),
    );
  }
}

Widget _requestsList(List<Request> givenPage) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(40, 0, 40, 0),
    child: ListView.separated(
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemBuilder: (context, index) {
        return ElevatedButton(
          child: Card(
            child: Text(givenPage[index].name),
          ),
          onPressed: () => showDialog<String>(
            /*On press we want to ask the user to verify if they want to send
          an invite to the requester*/
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Would you like to help this person?'),
              content: const Text("We'll send them an invite to start a live chat."),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: givenPage.length,
    ),
  );
}

Widget _friendsList(List<Friend> givenList) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(40, 0, 40, 0),
    child: ListView.separated(
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemBuilder: (context, index) {
        return BouncingButton(
          onPress: () {},
          child: Container(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [],
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Text(
                      givenList[index].name[0],
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        givenList[index].name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: givenList.length,
    ),
  );
}
