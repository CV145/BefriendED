
import 'package:befriended_flutter/app/home/home.dart';
import 'package:befriended_flutter/app/user_profile/user_profile_page.dart';
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:flutter/material.dart';
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

  FirebaseProvider provider = FirebaseProvider();

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
              HomePageStatus.support == widget.selectedPage
                  ? Icons.groups_rounded
                  : Icons.groups_outlined,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 30,
            ),
            onPressed: () {
              widget.onTapped(HomePageStatus.support, 1);
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
            child:  IconButton(
                  icon: Icon(
                    Icons.account_circle_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                      CupertinoScaffold.showCupertinoModalBottomSheet<String>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          //Need a way to pass in User object
                          return UserProfilePage();
                        },
                        shadow: const BoxShadow(
                          color: Colors.transparent,
                        ),
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
              widget.onTapped(HomePageStatus.setting, 2);
            },
          ),
        ],
      ),
    );
  }
}
