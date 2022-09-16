import 'dart:developer';

import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/constants/RouteConstants.dart';
import 'package:befriended_flutter/app/country_picker/country_picker.dart';
import 'package:befriended_flutter/app/login/view/otp.dart';
import 'package:befriended_flutter/app/widget/bouncing_button.dart';
import 'package:befriended_flutter/app/widget/text_field.dart';
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, this.isBackAllowed = false}) : super(key: key);

  final bool isBackAllowed;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  late Animation<Offset> _scaleAnimation;
  late AnimationController _scaleController;

  @override
  void initState() {
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(-1, 0))
            .animate(_scaleController);
    super.initState();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void navigateToOTP() {
    _scaleController.forward();
    Navigator.push<dynamic>(
      context,
      // MySlideTransition(oldScreen: widget, newScreen: const OTPScreen()),
      PageRouteBuilder<Null>(
        settings: const RouteSettings(name: RouteConstants.otp),
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return OTPScreen();
        },
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    ).then(
      (dynamic value) {
        log('back');
        _scaleController.reverse();
      },
    );
  }

  void generateOtp() {
    final state = context.read<AppCubit>().state;
    final contact = state.countryCode + state.phoneNumber;

    FirebaseProvider().verifyPhone(contact, context, navigateToOTP);
  }

  //build method for UI Representation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CupertinoScaffold(
        body: SizedBox(
          width: double.infinity,
          child: Container(
            padding: const EdgeInsets.all(50),
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                if (widget.isBackAllowed)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                Hero(
                  tag: 'PhoneVerification',
                  child: Text(
                    'Phone Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SlideTransition(
                  position: _scaleAnimation,
                  child: Text(
                    'OTP will be asked in the next page',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Spacer(flex: 1),
                SlideTransition(
                  position: _scaleAnimation,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        CountryPickerWidget(),
                        Expanded(
                          child: BlocBuilder<AppCubit, AppState>(
                            builder: (context, state) {
                              return MyTextField(
                                label: 'Phone Number',
                                value: state.phoneNumber,
                                onChanged: (value) {
                                  context
                                      .read<AppCubit>()
                                      .phoneNumberChanged(value);
                                },
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                keyboardType: TextInputType.number,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 7),
                Hero(
                  tag: 'PhoneVerificationButton',
                  child: BouncingButton(
                    label: 'Send OTP',
                    onPress: () {
                      generateOtp();
                    },
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
