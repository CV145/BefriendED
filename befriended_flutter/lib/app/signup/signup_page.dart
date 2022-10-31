//UI for creating new account

import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/constants/RouteConstants.dart';
import 'package:befriended_flutter/app/home/view/home.dart';
import 'package:befriended_flutter/app/widget/snack_bar.dart';
import 'package:befriended_flutter/app/widget/text_field.dart';
import 'package:befriended_flutter/services/authentication/account_authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final AccountAuthenticationService authService =
      AccountAuthenticationService();

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
              value: context.read<AppCubit>().state.name,
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
                await authService.createNewAccount(email, password);
                createAccount(result: result, context: context);
              },
              child: const Text('SIGN UP'),
            ),
          ],
        ),
      ),
    );
  }

  void createAccount({required String? result, required BuildContext context}) {
    if (result != null) {
      if (result.contains('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          singleLineSnackBar(context, result),
        );
        return;
      }

      //Create a new user and store it in the database
      context.read<AppCubit>().setUser(
        firestoreID: result,
        name: name,
        email: email,
      );

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
