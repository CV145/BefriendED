//UI for creating new account

import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: ListView(
            children: const [
              TextField(
                decoration: InputDecoration(labelText: 'Full Name'),
                //controller: fullNameController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
               // controller: emailController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
                //controller: passwordController,
              ),
            ],
          ),
      ),
    );
  }
}
