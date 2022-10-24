import 'package:befriended_flutter/app/affirmations/view/affirmations.dart';
import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/availability_schedule/cubit/availability_schedule_cubit.dart';
import 'package:befriended_flutter/app/availability_schedule/view/availability_schedule.dart';
import 'package:befriended_flutter/app/login/login.dart';
import 'package:befriended_flutter/app/setting/view/sign_out.dart';
import 'package:befriended_flutter/app/widget/bouncing_button.dart';
import 'package:befriended_flutter/app/widget/delay_sizedbox.dart';
import 'package:befriended_flutter/app/widget/scroll_column_constraint.dart';
import 'package:befriended_flutter/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key})
      : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<SettingsPage> {
  bool _affirmationsVisibility = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Stack(
          children: <Widget>[
            _getSettingsPage(context, state),
            Visibility(
              visible: _affirmationsVisibility,
              child: AffirmationsPage(closeAffirmationsOnTap:
              _closeAffirmationsOnTap,),
            ),
          ],
        );
      },
    );
  }

  void _closeAffirmationsOnTap()
  {
    _affirmationsVisibility = false;
    setState(() {
      // Update UI
    });
  }

  Widget _getSettingsPage(BuildContext context, AppState state) {
    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              child: Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 50),
                // padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                child: Text(
                  state.name.isNotEmpty ? state.name[0] : '',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                state.name,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(30, 40, 30, 0),
              child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 12, 10, 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .onSecondary
                          .withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(3, 3),
                    ),
                  ],
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Set Daily Affirmations',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        //Replace settings page with affirmations page
                        //Or make affirmations pop-up over settings
                        _affirmationsVisibility = true;

                        //Update UI
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(30, 40, 30, 0),
              child: BouncingButton(
                onPress: () {},
                child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 12, 10, 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondary
                            .withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(3, 3),
                      ),
                    ],
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rate',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Help us by rating',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            Text(
                              'Befriended 5 stars',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            SizedBox(
                              height: 20,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rate_rounded,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  size: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(30, 40, 30, 40),
              child: Row(
                children: [
                  Expanded(
                    child: BouncingButton(
                      onPress: () {},
                      child: Container(
                        height: 100,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          10,
                          12,
                          10,
                          12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.onSecondary,
                              blurRadius: 8,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chat with us!',
                              style:
                                  Theme.of(context).primaryTextTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "We're very friendly!",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displaySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: BouncingButton(
                      onPress: () {
                        CupertinoScaffold.showCupertinoModalBottomSheet<String>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return const SignOut();
                          },
                          shadow: const BoxShadow(
                            color: Colors.transparent,
                          ),
                        );
                      },
                      child: Container(
                        height: 100,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 12, 10, 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondary
                                  .withOpacity(0.5),
                              blurRadius: 8,
                              offset: const Offset(3, 3),
                            ),
                          ],
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sign out',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "We're always here for you :)",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text(
                  'NEDA Toll Free Phone Number: 1-800-931-2237',
                  textAlign: TextAlign.center,
                ),
                Text(
                  "For 24/7 crisis support, text 'NEDA' to 741741",
                  textAlign: TextAlign.center,
                )
              ],
            ),
            const Padding(padding: EdgeInsets.all(20),),
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginScreen(isBackAllowed: true),
      transitionDuration: const Duration(seconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
