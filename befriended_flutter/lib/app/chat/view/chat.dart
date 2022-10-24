/*
import 'package:befriended_flutter/animations/fade_animation.dart';
import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/constants/RouteConstants.dart';
import 'package:befriended_flutter/app/login/login.dart';
import 'package:befriended_flutter/app/support/support.dart';
import 'package:befriended_flutter/app/widget/bouncing_button.dart';
import 'package:befriended_flutter/app/widget/delay_sizedbox.dart';
import 'package:befriended_flutter/app/widget/scroll_column_constraint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   initState() {
//     super.initState();
//     _controller = BottomSheet.createAnimationController(this);
//     _controller.duration = Duration(seconds: 1);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      // child: Text('secnd Page'),
      child: ScrollColumnConstraint(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Connect with our buddy friend, for a friendly support',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50,
                ),
                DealySizedBox(
                  width: 200,
                  height: 200,
                  child: SvgPicture.asset(
                    'assets/images/chat.svg',
                    width: 200,
                    height: 200,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ],
            ),
            // const Spacer(),
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                if (state.isLoggedIn) {
                  return Column(
                    children: [
                      BouncingButton(
                        label: 'Start chat',
                        onPress: () {},
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          child: Text(
                            'No previous messages found',
                            style: Theme.of(context).textTheme.displaySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    BouncingButton(
                      label: 'Login',
                      onPress: () {
                        Navigator.push<dynamic>(context, _createRoute());
                      },
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Text(
                          'Identity verification is needed to start the chat',
                          style: Theme.of(context).textTheme.displaySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );

    return Container(
      // child: Text('secnd Page'),
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          children: [
            Container(
              height: 30,
              // height: MediaQuery.of(context).size.height * 0.70,
              padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),

              margin: const EdgeInsetsDirectional.fromSTEB(30, 50, 30, 0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.all(Radius.circular(40)),
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
                tabs: [
                  Tab(
                    child: Text('Previous chat'),
                  ),
                  Tab(
                    child: Text('Buddy'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _chatList(onlineList),
                  _buddyRequest(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const onlineList = [
    ChatMessage('Ria', 'Thanks a lot! it really helps'),
    ChatMessage('Michel', 'Happy talking to you'),
  ];

  static const befriendList = [
    ChatMessage('Abbey', "Can't eat"),
    ChatMessage('Jia', 'Depression'),
    ChatMessage('Owen', 'Just to talk'),
    ChatMessage('Sheldon', 'Overweight'),
    ChatMessage('Thor', 'Appearance'),
  ];

  static const chatList = [
    ChatMessage('Hanifa', 'Have a nice day'),
    ChatMessage('Celine', 'Hello Celine, how are you ?'),
  ];

  Widget _buddyRequest(BuildContext context) {
    return ScrollColumnConstraint(
      child: Container(
        margin: const EdgeInsetsDirectional.fromSTEB(30, 50, 30, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Column(
            //   children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              'Our team will soon find a suitable buddy coach for you!',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            DealySizedBox(
              width: 200,
              height: 200,
              child: SvgPicture.asset(
                'assets/images/buddy.svg',
                width: 200,
                height: 200,
                fit: BoxFit.scaleDown,
              ),
            ),
            //   ],
            // ),
            // const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _chatList(List<ChatMessage> list) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(40, 0, 40, 30),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemBuilder: (context, index) {
                return BouncingButton(
                  onPress: () {},
                  child: Container(
                    // margin: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        // BoxShadow(
                        //   color: Theme.of(context)
                        //       .colorScheme
                        //       .onSecondary
                        //       .withOpacity(0.3),
                        //   blurRadius: 3,
                        //   offset: Offset(0, 1),
                        // ),
                      ],
                      // color:
                      //     Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 0),
                            // padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            child: Text(
                              list[index].name[0],
                              // state.name.isNotEmpty ? state.name[0] : '',
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
                                list[index].name,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(height: 4),
                              Text(
                                list[index].message,
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
              itemCount: list.length,
            ),
          ),
          BouncingButton(
            label: 'Start new chat',
            onPress: () {},
          )
        ],
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder<Null>(
      settings: const RouteSettings(name: RouteConstants.login),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginScreen(isBackAllowed: true),
      transitionDuration: const Duration(seconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // void showLoginModel() {
  //   showModalBottomSheet<dynamic>(
  //     context: context,
  //     transitionAnimationController: _controller,
  //     builder: (context) {
  //       return Container(
  //         height: MediaQuery.of(context).size.height,
  //         child: Text("Your bottom sheet"),
  //       );
  //     },
  //   );
  // }
}
*/