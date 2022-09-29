// ignore_for_file: lines_longer_than_80_chars

import 'package:befriended_flutter/services/local_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AffirmationsPage extends StatefulWidget {
  const AffirmationsPage({Key? key}) : super(key: key);

  @override
  State<AffirmationsPage> createState() => _AffirmationsState();
}

class _AffirmationsState extends State<AffirmationsPage> {
  late final LocalNotificationService service;
  List<Widget> _cardList = [];

  @override
  void initState() {
    service = LocalNotificationService();
    service.initialize();
    super.initState();
  }

  void _addCardWidget() {
    setState(() => {_cardList.add(_card())});
  }

  //Custom card widget
  Widget _card() {
    return SizedBox(
      height: 80,
      child: ElevatedButton(
        onPressed: () async {
          await service.showNotification(
              id: 0,
              title: 'Notification Title',
              body: 'Affirmation quote goes here');
        },
        child: const Text('Show quote notification'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scheduled Affirmations',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: ListView.builder(
        itemCount: _cardList.length,
        itemBuilder: (context, index) {
          return _cardList[index];
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: _addCardWidget,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
