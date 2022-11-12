// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:befriended_flutter/bootstrap.dart';
import 'package:befriended_flutter/firebase_options.dart';
import 'package:befriended_flutter/local_storage/local_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //name: 'befriended',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('Finished initialization of Firebase app');

  /*
  //Test HTTP request
  final response =
  await http.get(
    Uri.parse('https://befriendedbackend20221111105003.azurewebsites.net'),);

  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    //Server returned a 200 OK response
    print('Response body: ${response.body}');
  }
  else {
    throw Exception('HTTP request failed');
  } */

  final localStorage = LocalStorage(
    plugin: await SharedPreferences.getInstance(),
  );

  await bootstrap(localStorage);

  /*
  //Setting up FCM
  final messaging = FirebaseMessaging.instance;
  final fcmToken = await messaging.getToken(vapidKey:
  'BJmOrF7CN3LH32Rqf0UGHYmqUZYliIxMa1NdSQxhtGhT6VTDzgrKOEGnirXq3fruLy3doSRmw1QCDn-seRycvDw');
  print('fcm token: $fcmToken');

  final settings = await messaging.requestPermission();

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); */


}

/*
  -For receiving messages in the background-

  Handle background messages by registering a onBackgroundMessage handler. When
  messages are received, an isolate is spawned (Android only, iOS/macOS does not
  require a separate isolate) allowing you to handle messages even when your
  application is not running.

  There are a few things to keep in mind about your background message handler:

  1. It must not be an anonymous function.
  2. It must be a top-level function (e.g. not a class method which
  requires initialization).
  3. It must be annotated with @pragma('vm:entry-point') right above the
  function declaration (otherwise it may be removed during tree shaking for
  release mode).
   */
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(); //In separate Isolate

  print("Handling a background message: ${message.messageId}");

  /*
  Since the handler runs in its own isolate outside your applications context,
  it is not possible to update application state or execute any UI impacting
  logic. You can, however, perform logic such as HTTP requests, perform IO
  operations (e.g. updating local storage), communicate with other plugins etc.

  It is also recommended to complete your logic as soon as possible. Running
  long, intensive tasks impacts device performance and may cause the OS to
  terminate the process. If tasks run for longer than 30 seconds, the device
  may automatically kill the process.
   */
}
