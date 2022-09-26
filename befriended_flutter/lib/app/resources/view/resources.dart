import 'package:flutter/material.dart';

class ResourcesPage extends StatelessWidget
{
  const ResourcesPage({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
      const [
        Text('NEDA Toll Free Phone Number: 1-800-931-2237'),
        Text("For 24/7 crisis support, text 'NEDA' to 741741")
      ],
    );


  }
}
