import 'package:befriended_flutter/animations/fade_up_animation.dart';
import 'package:befriended_flutter/app/constants/RouteConstants.dart';
import 'package:befriended_flutter/app/home/home.dart';
import 'package:befriended_flutter/app/signup/signup_page.dart';
import 'package:befriended_flutter/app/user_profile/user_global_state.dart';
import 'package:befriended_flutter/app/widget/bouncing_button.dart';
import 'package:befriended_flutter/app/widget/snack_bar.dart';
import 'package:befriended_flutter/services/authentication/account_authentication_service.dart';
import 'package:flutter/material.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  AccountAuthenticationService authService = AccountAuthenticationService();

  String email = '';
  String password = '';
  bool _isHidden = true;

  //Verify the given email and password
  void verifyLoginAndNavigate({required String? result,
    required BuildContext context,})
  {
    if (result != null) {
      if (result.contains('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          singleLineSnackBar(context, result),
        );
        return;
      }

      print(result);
      print('User built with above ID ${UserGlobalState.currentUser.name}');

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
                  child: Column(
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              suffix: Icon(Icons.email),
                            ),
                            onChanged: (value) {
                              email = value;
                            },
                          ),
                          const Divider(),
                          TextField(
                            obscureText: _isHidden,
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Password',
                              suffix: InkWell(
                                onTap: _togglePasswordView,
                                child: Icon(
                                  _isHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                        ],
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
                    onPress: () async {
                      final result =
                      await authService.signIn(email, password);
                      verifyLoginAndNavigate(result: result, context: context);
                    },
                  ),
                ),
              ),
              FadeUpAnimation(
                delay: 800,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push<dynamic>(context, _navigateToSignUpPage());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        "-> Don't have an account? Sign up here. <-",
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Route _navigateToSignUpPage() {
    return PageRouteBuilder<void>(
      settings: const RouteSettings(name: RouteConstants.signUp),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SignUpPage(),
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

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
