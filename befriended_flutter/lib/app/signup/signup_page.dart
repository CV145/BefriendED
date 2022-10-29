//UI for creating new account

import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

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
            const TextField(
              decoration: InputDecoration(labelText: 'Full Name'),
              //controller: fullNameController,
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Email'),
              // controller: emailController,
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Password'),
              //controller: passwordController,
            ),
            const Padding(padding: EdgeInsets.all(25)),
            ElevatedButton(onPressed: () {  },
            child: const Text('SIGN UP'),),
          ],
        ),
      ),
    );
  }
}
