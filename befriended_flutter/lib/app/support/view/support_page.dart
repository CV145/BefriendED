
import 'package:befriended_flutter/app/support/chat_message.dart';
import 'package:befriended_flutter/app/support/friend_model.dart';
import 'package:befriended_flutter/app/support/request_model.dart';
import 'package:befriended_flutter/app/widget/bouncing_button.dart';
import 'package:flutter/material.dart';



class SupportPage extends StatefulWidget {
  const SupportPage({
    Key? key,
  }) : super(key: key);

  @override
  SupportPageState createState() => SupportPageState();
}

class SupportPageState extends State<SupportPage> {

  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return buildSupportPage(context);
  }

  Widget buildSupportPage(BuildContext context) {
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
                  child: Text('Chats'),
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
                _requestsList(requestsList),
                _chatList(chatList),
                _friendsList(friendsList),
              ],
            ),
          ),
        ],
      ),
    );
  }

   List<Request> requestsList = [
    /*Request(userPool.pool[9]),
    Request(userPool.pool[8]),
    Request(userPool.pool[7]) */
  ];

    List<Friend> friendsList = [
   /* Friend(user: userPool.pool[3]),
    Friend(user: userPool.pool[4]),
    Friend(user: userPool.pool[5]),
    Friend(user: userPool.pool[6]),
    Friend(user: userPool.pool[7]),*/
  ];

  List<ChatMessage> chatList = [
    //ChatMessage(userPool.pool[8], 'Have a nice day'),
    //ChatMessage(userPool.pool[9],
    //    'Hello Celine, how are you ?'),
  ];

  //The following returns ListViews using the given lists
  Widget _chatList(List<ChatMessage> givenList) {
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Text(
                        givenList[index].senderName[0],
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
                          givenList[index].senderName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          givenList[index].message,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
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

  Widget _requestsList(List<Request> givenList)
  {
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
                        borderRadius:
                        const BorderRadius.all(Radius.circular(50)),
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
                        Wrap(children: givenList[index].topics.
                        map((topic)
                        => Chip(label: Text(topic.name)),).toList(),),
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

  Widget _friendsList(List<Friend> givenList)
  {
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
                        borderRadius:
                        const BorderRadius.all(Radius.circular(50)),
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
}
