import 'dart:developer';

import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/chat/view/chat.dart';
import 'package:befriended_flutter/app/home/view/bottom_navigator.dart';
import 'package:befriended_flutter/app/hometab/view/hometab.dart';
import 'package:befriended_flutter/app/setting/view/setting.dart';
import 'package:befriended_flutter/app/support/support.dart';
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:overlay_support/overlay_support.dart';

enum HomePageStatus { home, chat, blog, setting }

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

Map<HomePageStatus, Function> homePages = {
  HomePageStatus.home: () => const HomeTabPage(key: ValueKey(1)),
  HomePageStatus.chat: () => const ChatPage(key: ValueKey(2)),
  HomePageStatus.blog: () => const SupportPage(key: ValueKey(3)),
  HomePageStatus.setting: () => const SettingsPage(key: ValueKey(4)),
};

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<LoginCubit>(
//           create: (context) =>
//               LoginCubit(localStorage: context.read<LocalStorage>()),
//         ),
//       ],
//       child: const HomePageView(),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> with WidgetsBindingObserver {
  HomePageStatus _selectedPage = HomePageStatus.home;
  int _selectedIndex = 1;
  int _previousIndex = 0;
  Widget? _selectedPageWidget =
      homePages[HomePageStatus.home]?.call() as Widget;

  late final FirebaseMessaging _messaging;
  late int _totalNotifications;
  PushNotification? _notificationInfo;

  @override
  void initState() {
    super.initState();
    _totalNotifications = 0;
    registerNotification();
    checkForInitialMessage();

    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'] as String,
        dataBody: message.data['body'] as String,
      );

      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });

    // online status observer
    WidgetsBinding.instance.addObserver(this);
    FirebaseProvider().updatePresence(true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed)
      FirebaseProvider().updatePresence(true);
    else
      FirebaseProvider().updatePresence(false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listenWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {},
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CupertinoScaffold(
          transitionBackgroundColor: Theme.of(context).colorScheme.primary,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      final inAnimation =
                          Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
                              .animate(animation);
                      final outAnimation =
                          Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
                              .animate(animation);
                      Animation<Offset> anim;
                      if (_previousIndex < _selectedIndex) {
                        //right to left
                        log(child.key.toString());
                        log(ValueKey(_selectedIndex).toString());
                        if (child.key == ValueKey(_selectedIndex)) {
                          print("in");
                          anim = inAnimation;
                        } else {
                          print("out");
                          anim = outAnimation;
                        }
                      } else {
                        //left to right
                        if (child.key == ValueKey(_selectedIndex)) {
                          anim = outAnimation;
                        } else {
                          anim = inAnimation;
                        }
                      }

                      return SlideTransition(
                        position: anim,
                        child: child,
                      );
                    },
                    // layoutBuilder: (currentChild, _) {
                    //   return currentChild;
                    // },
                    child: homePages[_selectedPage]?.call() as Widget,
                  ),
                ),
                MyBottomNavigator(
                  selectedPage: _selectedPage,
                  onTapped: onTapped,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTapped(HomePageStatus page, int index) {
    setState(() {
      _selectedPage = page;
      // _selectedPageWidget = homePages[page]?.call() as Widget;
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
  }

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'] as String,
          dataBody: message.data['body'] as String,
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });

        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // For handling notification when the app is in terminated state
  void checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'] as String,
        dataBody: initialMessage.data['body'] as String,
      );

      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: new BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$totalNotifications',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

// floatingActionButton: SizedBox(
        //   width: 50,
        //   height: 50,
        //   child: FittedBox(
        //     child: FloatingActionButton(
        //       backgroundColor: Theme.of(context).colorScheme.onPrimary,
        //       //Floating action button on Scaffold
        //       onPressed: () {
        //         //code to execute on button press
        //       },
        //       child: Icon(
        //         Icons.add_rounded,
        //         color: Theme.of(context).colorScheme.primary,
        //         size: 35,
        //       ), //icon inside button
        //     ),
        //   ),
        // ),
        // floatingActionButtonLocation: 
        // FloatingActionButtonLocation.centerDocked,
