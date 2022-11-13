import 'package:signalr_netcore/abort_controller.dart';
import 'package:signalr_netcore/binary_message_format.dart';
import 'package:signalr_netcore/default_reconnect_policy.dart';
import 'package:signalr_netcore/errors.dart';
import 'package:signalr_netcore/handshake_protocol.dart';
import 'package:signalr_netcore/http_connection.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/iconnection.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/iretry_policy.dart';
import 'package:signalr_netcore/itransport.dart';
import 'package:signalr_netcore/json_hub_protocol.dart';
import 'package:signalr_netcore/long_polling_transport.dart';
import 'package:signalr_netcore/msgpack_hub_protocol.dart';
import 'package:signalr_netcore/server_sent_events_transport.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:signalr_netcore/signalr_http_client.dart';
import 'package:signalr_netcore/text_message_format.dart';
import 'package:signalr_netcore/utils.dart';
import 'package:signalr_netcore/web_socket_transport.dart';
import 'package:signalr_netcore/web_supporting_http_client.dart';


///Client class that communicates to a SignalR server for chatting
class SignalRClient {
  /// The location of the SignalR Server. When making cross domain requests,
  /// the client code must use an absolute URL instead of a relative URL.
  /// For cross domain requests, change .withUrl("/chathub") to
  /// .withUrl("https://{App domain name}/chathub").
  static const serverUrl = 'https://localhost:7176/chatHub';

  ///The connection to the Hub on the SignalR Server
  static late final HubConnection _hubConnection;

  ///Creates the connection by using the HubConnectionBuilder.
  ///When the connection is closed, print out a message to the console.
  static Future<void> createConnection() async {
    _hubConnection = HubConnectionBuilder().withUrl(serverUrl)
    /*Configure the Hub with msgpack protocol*/
    .withHubProtocol(MessagePackHubProtocol())
    .withAutomaticReconnect()
    .build();


    _hubConnection.onclose( ({Exception? error}) => print('Connection Closed'));
    await _hubConnection.start()?.then((void f){
      print('Connection to local host established');
    });
  }

  ///Invoke the sample function on the server.
  static Future<void> invokeSimpleFunction() async {
    final result = await
    _hubConnection.invoke(
        'MethodOneSimpleParameterSimpleReturnValue',
        args: <Object>['ParameterValue'],);
    print("Result: '$result");
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
