import 'package:befriended_flutter/app/local_database.dart';
import 'package:befriended_flutter/app/models/chat_invite.dart';
import 'package:befriended_flutter/app/models/chat_meeting.dart';
import 'package:befriended_flutter/app/models/friend_model.dart';
import 'package:befriended_flutter/app/models/request_model.dart';
import 'package:befriended_flutter/app/signalr_client.dart';
import 'package:befriended_flutter/app/views/chat_room_page.dart';
import 'package:befriended_flutter/app/views/widget/bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({
    Key? key,
  }) : super(key: key);

  @override
  SupportPageState createState() => SupportPageState();
}

class SupportPageState extends State<SupportPage> {
  List<Request?> requests = [];
  List<ChatMeeting> scheduledChats = [];
  List<ChatInvite> invites = [];
  List<ChatInvite> outgoingInvites = [];
  List<ChatInvite> declinedInvites = [];
  List<Friend> friends = [];
  bool chatEnabled = false;
  late DateTime? nextScheduledTime;

  @override
  void initState() {
    refreshRequests();
    refreshInvites();
    refreshSchedule();
    friends = LocalDatabase.getLoggedInUser().friendsList;
    super.initState();
  }

  Future<void> sendInvite(
    String receiverID,
    String receiverName,
    DateTime scheduledTime,
  ) async {
    final result = SignalRClient.sendChatInviteTo(
      receiverID,
      receiverName,
      scheduledTime.year,
      scheduledTime.month,
      scheduledTime.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );
    print(result);
  }

  Future<void> scheduleChatWith(
      String inviteSenderID,
      DateTime scheduledTime,
      ) async {
    await SignalRClient.scheduleChatWith(inviteSenderID,
        scheduledTime.year, scheduledTime.month, scheduledTime.day,
        scheduledTime.hour, scheduledTime.minute,);
  }

  Future<void> refreshRequests() async {
    final loadedRequests = LocalDatabase.refreshRequests(10);
    await loadedRequests.then((value) => requests = value);
    setState(() {});
  }

  Future<void> refreshInvites() async {
    await LocalDatabase.refreshChatInvites().then(
      (value) {
        invites = LocalDatabase.getLoggedInUser().receivedInvites;
        setState(() {});
      },
    );
    await LocalDatabase.refreshOutgoingInvites().then(
      (value) {
        outgoingInvites = LocalDatabase.getLoggedInUser().outgoingInvites;
        for (final invite in outgoingInvites) {
          if (invite.isDeclined) {
            declinedInvites.add(invite);
            outgoingInvites.removeWhere((element) => element == invite);
          }
        }
        setState(() {});
      }
    );

  }
  
  Future<void> refreshSchedule() async {
    await LocalDatabase.refreshScheduledChats().then(
        (value) {
          scheduledChats = LocalDatabase.getLoggedInUser().scheduledChats;
          print('Scheduled chats list:');
          for(final chat in scheduledChats) {
            print(chat.year);
            print(chat.month);
            print(chat.day);
            print(chat.hour);
            print(chat.minute);
            print('');
          }
          //If current time is within the next scheduled chat interval, enable
          //chat, possibly passing in other user ID too
          final currentDate = DateTime.now();
          nextScheduledTime = LocalDatabase.getNextScheduledChatTime();
          if (nextScheduledTime != null){
            final nextTime = nextScheduledTime as DateTime;
            if (currentDate.isAfter(nextTime) &&
                currentDate.isBefore(nextTime.add(const Duration(minutes: 30)),
                )
            ) {
              chatEnabled = true;
            }
          } else {
            chatEnabled = false;
          }
        });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return buildSupportPage(context);
  }

  void navigateToChatRoomPage({
    required BuildContext context,
    required String otherUserID,
  }) {
    //Navigate to chat room page
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (context) => ChatRoomPage(otherUserID: otherUserID,),
      ),
    );
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
                  child: Text('Invites'),
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
                buildRequestsTab(),
                buildInvitesTab(),
                buildFriendsTab(friends),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Creates data for calendar using ChatMeetings
  DataSource getCalendarDataSource()
  {
    //Make an appointment for each scheduled chat meeting
    final List appointments = <Appointment>[];
    for(final meeting in LocalDatabase.getLoggedInUser().scheduledChats)
    {
      final chatTime = DateTime(meeting.year, meeting.month, meeting.day,
      meeting.hour, meeting.minute,);
      appointments.add(Appointment(
          startTime: chatTime,
          endTime: chatTime.add(const Duration(minutes: 30)),
          subject: 'Chat with ${meeting.chattingWithName}',
          ),
      );
    }
    return DataSource(appointments);
  }

  //The following returns ListViews using the given lists
  Widget buildInvitesTab() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            const Text('Chat Schedule'),
            SfCalendar(
              view: CalendarView.schedule,
              firstDayOfWeek: 1,
              dataSource: getCalendarDataSource(),
            ),
            const Divider(),
            ElevatedButton(
                onPressed: (){
                  if (chatEnabled) {
                    navigateToChatRoomPage(context: context,
                        otherUserID: scheduledChats[0].chattingWithID,);
                  } else {}
                },
                child:
                LocalDatabase.getLoggedInUser().scheduledChats.isNotEmpty?
                Text( 'Next: ${LocalDatabase.getNextScheduledChatTimeString()}')
                : const Text('Schedule a chat with someone!'),
            ),
            const Text('Incoming'),
            Column(
              //Incoming invites
              children: invites.map((inviteEntry) {
                return Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(inviteEntry.fromName),
                      Text('For: ${inviteEntry.month}/${inviteEntry.day} at ${inviteEntry.hour}:${inviteEntry.minute}'),
                      IconButton(
                        onPressed: () {
                          //accept invite and schedule chat
                          final date = DateTime(inviteEntry.year,
                              inviteEntry.month, inviteEntry.day,
                              inviteEntry.hour, inviteEntry.minute,);
                          scheduleChatWith(inviteEntry.senderID, date);
                          refreshSchedule();
                          //delete this entry
                          setState(() {
                            invites.removeWhere((element) {
                              return element.fromName == element.fromName;
                            });
                          });
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.greenAccent,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          //Database needs to know that the invite's declined
                          LocalDatabase.declineInvite(inviteEntry);
                          setState(() {
                            invites.removeWhere((element) {
                              return element.fromName == element.fromName;
                            });
                          });
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.redAccent,
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
            const Text('Sent'),
            Column(
              //Outgoing invites
              children: outgoingInvites.map((inviteEntry) {
                  return Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(inviteEntry.toName),
                        Text('For: ${inviteEntry.month}/${inviteEntry.day} at ${inviteEntry.hour}:${inviteEntry.minute}'),
                      ],
                    ),
                  );
              }).toList(),
            ),
            const Text('Declined'),
            Column(
              children: declinedInvites.map((inviteEntry) {
                return Card(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      const Text('(declined)'),
                      Text(inviteEntry.toName),
                      Text('For: ${inviteEntry.month}/${inviteEntry.day} at ${inviteEntry.hour}:${inviteEntry.minute}'),
                    ],
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRequestsTab() {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: requests.map((requestEntry) {
          if (requestEntry == null) {
            return const SizedBox();
          }
          return ElevatedButton(
            onPressed: () {
              showDialog<String>(
                /*On press we want to ask the user to verify if
                 they want to send an invite to the requester */
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Would you like to help this person?'),
                  content: const Text(
                    "We'll send them an invite to start a live chat.",
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      //Send a chat invite to Requester
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2024),
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          helpText: 'Schedule a chat time!',
                        );
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (selectedTime != null && selectedDate != null) {
                          final scheduledTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                          await sendInvite(
                            requestEntry.userID,
                            requestEntry.name,
                            scheduledTime,
                          );
                        }
                        await refreshInvites();
                        Navigator.pop(context, 'Yes');
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            },
            child: Card(
              color: Colors.white38,
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                    //color: Colors.blueAccent,
                    ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(requestEntry?.name ?? ''),
                  Row(
                    children: requestEntry.topicChips,
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
    // ),
    //);
  }

  Widget buildFriendsTab(List<Friend> givenList) {
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
