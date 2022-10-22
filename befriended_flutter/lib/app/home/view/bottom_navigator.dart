import 'dart:developer';

import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/chat/view/chat.dart';
import 'package:befriended_flutter/app/constants/RouteConstants.dart';
import 'package:befriended_flutter/app/home/home.dart';
import 'package:befriended_flutter/app/home/view/common_menu.dart';
import 'package:befriended_flutter/app/hometab/view/hometab.dart';
import 'package:befriended_flutter/app/login/login.dart';
import 'package:befriended_flutter/app/user_profile/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class MyBottomNavigator extends StatefulWidget {

  //Stateful widget class constructor - specifies widget parameters needed
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
        boxShadow: const [
          BoxShadow(
            color: Colors.grey, //New
            blurRadius: 2,
            offset: Offset(0, -1),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
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
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                return IconButton(
                  icon: Icon(
                    Icons.account_circle_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    //Commented out logging in for debug purposes
                    //if (state.isLoggedIn) {
                      CupertinoScaffold.showCupertinoModalBottomSheet<String>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return UserProfilePage();
                        },
                        shadow: const BoxShadow(
                          color: Colors.transparent,
                        ),
                      );
                   /* } else {
                      Navigator.push<dynamic>(context, _createRoute());
                    }*/
                  },
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(
              HomePageStatus.setting == widget.selectedPage
                  ? Icons.more_horiz
                  : Icons.more_horiz,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              widget.onTapped(HomePageStatus.setting, 6);
            },
          ),
        ],
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder<void>(
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
