import 'dart:developer';

import 'package:befriended_flutter/app/views/bottom_navigator.dart';
import 'package:befriended_flutter/app/views/setting.dart';
import 'package:befriended_flutter/app/views/support_page.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum HomePageStatus {support, setting}

//Dictionary: Key - Enum value, Value - Widget constructor function
Map<HomePageStatus, Function> homePages = {
  HomePageStatus.support: () => const SupportPage(key: ValueKey(1)),
  HomePageStatus.setting: () => const SettingsPage(key: ValueKey(2)),
};


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  HomePageStatus _selectedPage = HomePageStatus.support;
  int _selectedIndex = 1;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          Tween<Offset>(begin: const Offset(1, 0),
                              end: Offset.zero,)
                              .animate(animation);
                      final outAnimation =
                          Tween<Offset>(begin: const Offset(-1, 0),
                              end: Offset.zero,)
                              .animate(animation);
                      Animation<Offset> anim;
                      if (_previousIndex < _selectedIndex) {
                        //right to left
                        log(child.key.toString());
                        log(ValueKey(_selectedIndex).toString());
                        if (child.key == ValueKey(_selectedIndex)) {
                          print('in');
                          anim = inAnimation;
                        } else {
                          print('out');
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
    );
  }

  void onTapped(HomePageStatus page, int index) {
    setState(() {
      _selectedPage = page;
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
  }
}

