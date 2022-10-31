import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/constants/RouteConstants.dart';
import 'package:befriended_flutter/app/launch/launch.dart';
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignOut extends StatefulWidget {
  const SignOut({
    Key? key,
  }) : super(key: key);

  @override
  State<SignOut> createState() => _SignOutState();
}

class _SignOutState extends State<SignOut> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(25, 50, 20, 70),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Are you sure?',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.left,
            ),
            Text(
              'You can sign in again anytime!',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.4)),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 30,
            ),
            buildMenu(
              text: 'Logout',
              iconData: Icons.logout_rounded,
              onPress: () {
                if (context.read<AppCubit>().state.isLoggedIn) {
                  FirebaseProvider().signOut();
                }
                //context.read<AppCubit>().clearLocalUser();
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder<void>(
                    settings: const RouteSettings(name: RouteConstants.launch),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const LaunchPage(),
                    transitionDuration: const Duration(milliseconds: 500),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(-1, 0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      final tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                  (Route<dynamic> route) => false,
                );
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
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.all(Radius.circular(40)),
            ),
            child: Icon(
              iconData,
              color: Theme.of(context).colorScheme.onPrimary,
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
}
