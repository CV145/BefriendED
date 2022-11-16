
import 'package:befriended_flutter/app/local_database.dart';
import 'package:befriended_flutter/app/views/home.dart';
import 'package:befriended_flutter/app/views/widget/snack_bar.dart';
import 'package:befriended_flutter/constants/route_constants.dart';
import 'package:flutter/material.dart';

//UI for creating new account
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {

  String email = '';
  String password = '';
  String name = '';
  bool _isHidden = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(fontSize: 14),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: ListView(
          children: [
            const Text('Create Account', style: TextStyle(fontSize: 36)),
            const Padding(padding: EdgeInsets.all(30)),
            TextField(
              onChanged: (value) {
                name = value;
              },
              decoration: const InputDecoration(
                hintText: 'Name',
              ),
            ),
            TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
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
            const Padding(padding: EdgeInsets.all(25)),
            ElevatedButton(
              onPressed: () async {
                final result =
                await LocalDatabase.createNewAccount(name, email, password);
                navigateToHomePage(authenticationResult: result,
                    context: context,);
              },
              child: const Text('SIGN UP'),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToHomePage({required String? authenticationResult,
    required BuildContext context,}) {
    if (authenticationResult != null) {
      if (authenticationResult.contains('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          singleLineSnackBar(context, authenticationResult),
        );
        return;
      }

      //Navigate to home page
      Navigator.push<dynamic>(
        context,
        PageRouteBuilder<void>(
          settings:
          const RouteSettings(name: RouteConstants.home),
          pageBuilder: (context, animation, secondaryAnimation) =>
          const HomePage(),
        ),
      );
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
