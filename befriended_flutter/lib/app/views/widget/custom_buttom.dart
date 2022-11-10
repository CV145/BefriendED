import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  // ignore: sort_constructors_first
  // const CustomButton(this.clickOnLogin);

  const CustomButton({Key? key, required this.clickOnLogin}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final Function clickOnLogin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        clickOnLogin(context);
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 253, 188, 51),
          borderRadius: BorderRadius.circular(36),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Send OTP',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}
