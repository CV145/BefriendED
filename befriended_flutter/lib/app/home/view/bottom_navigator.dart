import 'dart:developer';

import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/chat/view/chat.dart';
import 'package:befriended_flutter/app/constants/RouteConstants.dart';
import 'package:befriended_flutter/app/home/home.dart';
import 'package:befriended_flutter/app/home/view/common_menu.dart';
import 'package:befriended_flutter/app/hometab/view/hometab.dart';
import 'package:befriended_flutter/app/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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

class MyBottomNavigator extends StatefulWidget {
  const MyBottomNavigator({
    Key? key,
    required this.selectedPage,
    required this.onTapped,
  }) : super(key: key);

  final HomePageStatus selectedPage;
  final Function(HomePageStatus, int) onTapped;

  @override
  State<MyBottomNavigator> createState() => _MyBottomNavigatorState();
}

class _MyBottomNavigatorState extends State<MyBottomNavigator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        // borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey, //New
              blurRadius: 2.0,
              offset: Offset(0, -1))
        ],
      ),
      // shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(
              HomePageStatus.home == widget.selectedPage
                  ? Icons.home_rounded
                  : Icons.home_outlined,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 25,
            ),
            onPressed: () {
              widget.onTapped(HomePageStatus.home, 1);
            },
          ),
          IconButton(
            icon: Icon(
              HomePageStatus.chat == widget.selectedPage
                  ? Icons.question_answer_rounded
                  : Icons.question_answer_outlined,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              widget.onTapped(HomePageStatus.chat, 2);
            },
          ),
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.onPrimary,
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                return IconButton(
                  icon: Icon(
                    state.isLoggedIn ? Icons.add_rounded : Icons.login_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    if (state.isLoggedIn) {
                      CupertinoScaffold.showCupertinoModalBottomSheet<String>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return CommonMenu();
                        },
                        shadow: BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 0,
                          spreadRadius: 0,
                          offset: Offset(0, 0),
                        ),
                        // duration: Duration(milliseconds: 500),
                      );
                    } else {
                      Navigator.push<dynamic>(context, _createRoute());
                    }
                  },
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(
              HomePageStatus.blog == widget.selectedPage
                  ? Icons.groups_rounded
                  : Icons.groups_outlined,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 30,
            ),
            onPressed: () {
              widget.onTapped(HomePageStatus.blog, 3);
            },
          ),
          IconButton(
            icon: Icon(
              HomePageStatus.setting == widget.selectedPage
                  ? Icons.more_horiz
                  : Icons.more_horiz,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              widget.onTapped(HomePageStatus.setting, 4);
            },
          ),
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
}
