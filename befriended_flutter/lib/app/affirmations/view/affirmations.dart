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

  @override
  void initState() {
    service = LocalNotificationService();
    service.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduled Affirmations', style: TextStyle(fontSize: 15)),
      ),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () async {
              await service.showNotification(
                  id: 0,
                  title: 'Notification Title',
                  body: 'Affirmation quote goes here');
            },
            child: const Text("Show quote notification"),
          ),
          ElevatedButton(
            onPressed: () async {
              await service.showScheduledNotification(
                id: 0,
                title: 'Notification Title',
                body: 'Affirmation quote goes here',
                seconds: 4,
              );
            },
            child: const Text("Show delayed notification"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 10.0,
          child: Icon(Icons.add),
          onPressed: () => {print('I am a Floating button')}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
