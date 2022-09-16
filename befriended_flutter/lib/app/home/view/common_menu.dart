import 'package:befriended_flutter/app/buddy_request/buddy_request.dart';
import 'package:befriended_flutter/app/buddy_request/cubit/cubit.dart';
import 'package:befriended_flutter/app/chat/view/chat_window.dart';
import 'package:befriended_flutter/app/constants/RouteConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CommonMenu extends StatefulWidget {
  const CommonMenu({
    Key? key,
    // required this.selectedPage,
    // required this.onTapped,
  }) : super(key: key);

  // final HomePageStatus selectedPage;
  // final Function(HomePageStatus, int) onTapped;

  @override
  State<CommonMenu> createState() => _CommonMenuState();
}

class _CommonMenuState extends State<CommonMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.70,
      padding: const EdgeInsetsDirectional.fromSTEB(25, 50, 20, 50),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BlocBuilder<RequestBuddyCubit, RequestBuddyState>(
              builder: (context, state) {
                return buildMenu(
                  text: state.requestData?.matchedUserId == null
                      ? 'Connect with a buddy'
                      : 'Talk to your buddy',
                  iconData: Icons.link_rounded,
                  onPress: () {
                    if (state.requestData?.matchedUserId == null) {
                      showCupertinoModalBottomSheet<String>(
                        context: context,
                        expand: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return BuddyRequest();
                        },
                        shadow: BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 0,
                          spreadRadius: 0,
                          offset: Offset(0, 0),
                        ),
                        // duration: Duration(milliseconds: 500),
                      );
                    }
                  },
                );
              },
            ),
            const SizedBox(
              height: 50,
            ),
            buildMenu(
              text: 'Discuss now',
              iconData: Icons.keyboard_double_arrow_right_rounded,
              onPress: () {
                Navigator.push<dynamic>(context, _createRoute());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenu({
    required String text,
    required IconData iconData,
    required Function() onPress,
  }) {
    return InkWell(
      onTap: onPress,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15),
            // padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            child: IconButton(
              icon: Icon(
                iconData,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {},
            ),
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder<Null>(
      settings: const RouteSettings(name: RouteConstants.chat),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ChatWindowPage(),
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
