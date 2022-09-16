import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/availability_schedule/cubit/availability_schedule_cubit.dart';
import 'package:befriended_flutter/app/availability_schedule/view/availability_schedule.dart';
import 'package:befriended_flutter/app/login/login.dart';
import 'package:befriended_flutter/app/setting/view/sign_out.dart';
import 'package:befriended_flutter/app/widget/bouncing_button.dart';
import 'package:befriended_flutter/app/widget/delay_sizedbox.dart';
import 'package:befriended_flutter/app/widget/scroll_column_constraint.dart';
import 'package:befriended_flutter/app/widget/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage>
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
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return SizedBox(
          // child: Text('secnd Page'),
          child: ScrollColumnConstraint(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 50),
                    // padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
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
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    state.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                // const SizedBox(
                //   height: 40,
                // ),
                // Text(
                //   'Become a buddy friend and support in our mission',
                //   style: Theme.of(context).textTheme.titleMedium,
                //   textAlign: TextAlign.center,
                // ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 40, 30, 0),
                  child: BouncingButton(
                    onPress: () {
                      if (!context.read<AppCubit>().state.isLoggedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          singleLineSnackBar(context, 'Please login!'),
                        );
                      } else {
                        CupertinoScaffold.showCupertinoModalBottomSheet<String>(
                          context: context,
                          expand: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return AvailabilitySchedule();
                          },
                          shadow: BoxShadow(
                            color: Colors.transparent,
                            blurRadius: 0,
                            spreadRadius: 0,
                            offset: Offset(0, 0),
                          ),
                          // duration: Duration(milliseconds: 500),
                        ).then((value) {
                          // TODO handle error on save
                          context
                              .read<AvialabiliyScheduleCubit>()
                              .saveAvailability();
                        });
                      }
                    },
                    child: Container(
                      // margin: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 12, 10, 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondary
                                .withOpacity(0.5),
                            blurRadius: 8,
                            offset: Offset(3, 3),
                          ),
                        ],
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.schedule_rounded,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 26,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Update Availability',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'This help us match your buddy friend',
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 40, 30, 0),
                  child: Container(
                    // margin: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10, 12, 10, 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondary
                              .withOpacity(0.5),
                          blurRadius: 8,
                          offset: Offset(3, 3),
                        ),
                      ],
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Motivational Qoutes',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withOpacity(0.6),
                                    ),
                              ),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                activeColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                trackColor:
                                    Theme.of(context).colorScheme.secondary,
                                value: true,
                                onChanged: (bool value) {},
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'New message',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withOpacity(0.6),
                                    ),
                              ),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                activeColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                trackColor:
                                    Theme.of(context).colorScheme.secondary,
                                value: true,
                                onChanged: (bool value) {},
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 40, 30, 0),
                  child: BouncingButton(
                    onPress: () {},
                    child: Container(
                      // margin: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 12, 10, 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondary
                                .withOpacity(0.5),
                            blurRadius: 8,
                            offset: Offset(3, 3),
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
                                SizedBox(height: 4),
                                Text(
                                  "Help us by rating",
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                                Text(
                                  "Befriended 5 stars",
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                                SizedBox(
                                  height: 20,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star_rate_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
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
                  padding: EdgeInsetsDirectional.fromSTEB(30, 40, 30, 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: BouncingButton(
                          onPress: () {},
                          child: Container(
                            height: 100,
                            // margin: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 12, 10, 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  blurRadius: 8,
                                  offset: Offset(0, 5),
                                ),
                              ],
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chat with us!',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyMedium,
                                ),
                                SizedBox(height: 4),
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
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: BouncingButton(
                          onPress: () {
                            CupertinoScaffold.showCupertinoModalBottomSheet<
                                String>(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return SignOut();
                              },
                              shadow: BoxShadow(
                                color: Colors.transparent,
                                blurRadius: 0,
                                spreadRadius: 0,
                                offset: Offset(0, 0),
                              ),
                              // duration: Duration(milliseconds: 500),
                            );
                          },
                          child: Container(
                            height: 100,
                            // margin: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
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
                                  offset: Offset(3, 3),
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
                                SizedBox(height: 4),
                                Text(
                                  "We're always here for you :)",
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // const Spacer(),

                // Padding(
                //   padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                //   child: Text(
                //     'Identity verification is needed to become a buddy friend',
                //     style: Theme.of(context).textTheme.displaySmall,
                //     textAlign: TextAlign.center,
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
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
