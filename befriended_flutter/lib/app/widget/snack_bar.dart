import 'package:flutter/material.dart';

SnackBar singleLineSnackBar(BuildContext context, String label) {
  return SnackBar(
    content: Text(label),
    // duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.startToEnd,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: Theme.of(context).colorScheme.onPrimary,
    margin: EdgeInsets.only(
      bottom: MediaQuery.of(context).size.height - 80,
      right: 20,
      left: 20,
    ),
    elevation: 10,
    // action: SnackBarAction(
    //   label: 'ACTION',
    //   onPressed: () {},
    // ),
  );
}
