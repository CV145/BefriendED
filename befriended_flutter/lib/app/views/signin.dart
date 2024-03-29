import 'package:befriended_flutter/animations/fade_up_animation.dart';
import 'package:befriended_flutter/app/local_database.dart';
import 'package:befriended_flutter/app/views/home.dart';
import 'package:befriended_flutter/app/views/signup_page.dart';
import 'package:befriended_flutter/app/views/widget/bouncing_button.dart';
import 'package:befriended_flutter/app/views/widget/snack_bar.dart';
import 'package:befriended_flutter/constants/route_constants.dart';
import 'package:flutter/material.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {

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
        print(result);
        return;
      }
      print(result);
      print('User built with above ID ${LocalDatabase.getLoggedInUser().name}');
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
      resizeToAvoidBottomInset: true,
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
                          const Padding(padding: EdgeInsets.only(bottom: 15,
                              top: 15,),),
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
                          const Padding(padding: EdgeInsets.only(bottom: 55)),
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
                      await LocalDatabase.signIn(email, password);
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
