import 'package:befriended_flutter/animations/fade_up_animation.dart';
import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/constants/RouteConstants.dart';
import 'package:befriended_flutter/app/home/home.dart';
import 'package:befriended_flutter/app/login/login.dart';
import 'package:befriended_flutter/app/widget/bouncing_button.dart';
import 'package:befriended_flutter/app/widget/snack_bar.dart';
import 'package:befriended_flutter/app/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage>{

  void onPress(BuildContext context) {
    final name = context.read<AppCubit>().state.name;
    if (name.trim().isNotEmpty) {
      context.read<AppCubit>().saveName();
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder<void>(
          settings: const RouteSettings(name: RouteConstants.home),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomePage(),
          transitionDuration: const Duration(milliseconds: 1000),
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
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        singleLineSnackBar(context, 'Please enter your name'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SizedBox(
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              const Spacer(),
              Hero(
                tag: 'BefriendEDTitle',
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                  child: Text(
                    'BefriendED',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              FadeUpAnimation(
                delay: 500,
                child: Text(
                  'Nice to see you again! Please sign in.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 65,
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 50, maxWidth: 300),
                child: FadeUpAnimation(
                  delay: 800,
                  child: BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          MyTextField(
                            label: 'Username',
                            value: state.name,
                            onChanged: (value) {
                              context.read<AppCubit>().nameChanged(value);
                            },
                          ),
                          const Divider(),
                          MyTextField(
                            label: 'Email',
                            value: '', //Store email in state
                            onChanged: (value) {
                              //Email authentication goes here
                              //context.read<AppCubit>().nameChanged(value);
                            },
                          ),
                        ],);
                    },
                      ),
                  ),
                ),
              const Spacer(flex: 7),
              Container(
                constraints: const BoxConstraints(minWidth: 50, maxWidth: 300),
                child: FadeUpAnimation(
                  delay: 900,
                  child: BouncingButton(
                    label: 'Continue',
                    onPress: () => onPress(context),
                  ),
                ),
              ),
              FadeUpAnimation(
                delay: 800,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push<dynamic>(context, _createRoute());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        "Don't have an account? Sign up!",
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder<Null>(
      settings: const RouteSettings(name: RouteConstants.home),
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
