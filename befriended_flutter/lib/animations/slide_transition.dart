import 'package:flutter/material.dart';

class MySlideTransition extends PageRouteBuilder<dynamic> {
  final Widget oldScreen;
  final Widget newScreen;
  MySlideTransition({required this.oldScreen, required this.newScreen})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              newScreen,
          transitionDuration: Duration(seconds: 1),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Stack(
            children: <Widget>[
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              )
            ],
          ),
        );
}
