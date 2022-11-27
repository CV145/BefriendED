import 'package:befriended_flutter/app/local_database.dart';
import 'package:signalr_netcore/msgpack_hub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';


///Client class that communicates to a SignalR server for chatting
class SignalRClient {
  /// The location of the SignalR Server. When making cross domain requests,
  /// the client code must use an absolute URL instead of a relative URL.
  /// For cross domain requests, change .withUrl("/chathub") to
  /// .withUrl("https://{App domain name}/chathub").
  static const schedulingUrl =
      'https://befriendedsignalrchatserver.azurewebsites.net/schedulingHub';

  ///The connection to the Hub on the SignalR Server
  static late final HubConnection _schedulingConnection;


  ///Creates the connection by using the HubConnectionBuilder.
  ///When the connection is closed, print out a message to the console.
  static Future<void> createSchedulingConnection() async {
    _schedulingConnection = HubConnectionBuilder().withUrl(schedulingUrl)
    /*Configure the Hub with msgpack protocol*/
    .withHubProtocol(MessagePackHubProtocol())
    .withAutomaticReconnect()
    .build();
    _schedulingConnection.onclose( ({Exception? error}) => print('Connection Closed'));
    await _schedulingConnection.start()?.then((void f){
      print('Connection to local host established');
    });
  }

  ///Send a chat invite to the specified user.
  static Future<String?> sendChatInviteTo(String receiverFirebaseID,
      String receiverName, int year, int month, int day, int hour, int minute,)
  async {
    final result = await _schedulingConnection.invoke('SendInviteTo',
      args: <Object>[
        LocalDatabase.getLoggedInUser().uid,
        LocalDatabase.getLoggedInUser().name,
        receiverFirebaseID,
        receiverName,
        year,
        month,
        day,
        hour,
        minute
      ],
    );
    return result as String?;
  }

  ///Chats are scheduled when a user (receiver) accepts a chat invite from
  /// somebody (sender)
  static Future<void> scheduleChatWith(String inviteSenderID, int year,
      int month, int day, int hour, int minute,)
  async {
    await _schedulingConnection.invoke('ScheduleChat',
      args: <Object>[
        inviteSenderID,
        LocalDatabase.getLoggedInUser().uid,
        year,
        month,
        day,
        hour,
        minute
      ],
    );
  }
}

/*
A note about the parameter types #
All function parameters and return values are serialized/deserialized into/from
JSON by using the dart:convert package (json.endcode/json.decode).
Make sure that you:

use only simple parameter types
-or-
use objects that implements toJson() since that method is used by the
dart:convert package to serialize an object.

MSGPACK - It's like JSON but fast and small
All function parameters and return values are serialized/deserialized into/from
Msgpack by using the msgpack_dart package.
Make sure that you:

use only simple parameter types
-or-
Convert your classes to maps using Json encode/decode and then pass it to
msgpack or Serialize the message into bytes using msgpack_dart using custom
encoders and decoders before passing it to signalr
 */
