import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/login/login.dart';
import 'package:befriended_flutter/app/support/cubit/cubit.dart';
import 'package:befriended_flutter/app/support/view/support_request.dart';
import 'package:befriended_flutter/app/widget/bouncing_button.dart';
import 'package:befriended_flutter/app/widget/delay_sizedbox.dart';
import 'package:befriended_flutter/app/widget/scroll_column_constraint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChatMessage {
  const ChatMessage(this.name, this.message);

  final String name;
  final String message;
}

class SupportPage extends StatelessWidget {
  const SupportPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupportCubit, SupportState>(
      builder: (context, supportState) {
       // if (supportState.requestData?.isApproved ?? false) {
          return buildSupportPage(context);
        //}
        return buildJoinUs(context, supportState);
      },
    );
  }

  Widget buildSupportPage(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 3,
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
                  _chatList(requestsList),
                  _chatList(chatList),
                  _chatList(friendsList),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildJoinUs(BuildContext context, SupportState supportState) {
    return Container(
      padding: const EdgeInsets.all(50),
      child: ScrollColumnConstraint(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Join us!',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Become a buddy friend and support in our mission',
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
                    'assets/images/support.svg',
                    width: 200,
                    height: 200,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ],
            ),
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                if (state.isLoggedIn) {
                  return Column(
                    children: <Widget>[
                      BouncingButton(
                        label: supportState.requestData == null
                            ? 'Join'
                            : 'Update Request',
                        onPress: () {
                          CupertinoScaffold.showCupertinoModalBottomSheet<
                              String>(
                            context: context,
                            expand: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return SupportRequest();
                            },
                            shadow: const BoxShadow(
                              color: Colors.transparent,
                            ),
                            // duration: Duration(milliseconds: 500),
                          );
                        },
                      ),
                    ],
                  );
                }
                return Column(
                  children: <Widget>[
                    BouncingButton(
                      label: 'Login',
                      onPress: () {
                        Navigator.push<dynamic>(context, _createRoute());
                      },
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Text(
                        'Identity verification is needed to become a buddy friend',
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
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
  }

  static const requestsList = [
    ChatMessage('Vicky', 'Like to take about eating problems'),
    ChatMessage('Bala', 'Having depression thoughts'),
    ChatMessage('John', 'Expecting happy conversations'),
  ];

  static const friendsList = [
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

  Widget _chatList(List<ChatMessage> list) {
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
              // margin: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
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
                        const SizedBox(height: 4),
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
    );
  }

  Route _createRoute() {
    return PageRouteBuilder<Null>(
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
}
