//UI for creating new account

import 'package:befriended_flutter/app/constants/RouteConstants.dart';
import 'package:befriended_flutter/app/home/view/home.dart';
import 'package:befriended_flutter/app/widget/snack_bar.dart';
import 'package:befriended_flutter/app/widget/text_field.dart';
import 'package:befriended_flutter/services/authentication/account_authentication_service.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final AccountAuthenticationService authService =
      AccountAuthenticationService();

  String name = '';
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            MyTextField(
              label: 'Name',
              //value: state.name,
              onChanged: (value) {
                name = value;
              },
            ),
            MyTextField(
              label: 'Email',
              value: email,
              onChanged: (value) {
                email = value;
              },
            ),
            MyTextField(
              label: 'Password',
              //value: state.name,
              onChanged: (value) {
                password = value;
              },
            ),
            const Padding(padding: EdgeInsets.all(25)),
            ElevatedButton(
              onPressed: () async {
                final result =
                await authService.createNewAccount(email, password);

                print('Auth result: $result');

                if (result) {
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
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    singleLineSnackBar(context, 'Sign-up failed'),
                  );
                }
              },
              child: const Text('SIGN UP'),
            ),
          ],
        ),
      ),
    );
  }
}
