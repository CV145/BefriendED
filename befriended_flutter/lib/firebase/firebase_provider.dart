import 'package:firebase_database/firebase_database.dart';

/*
Firebase Realtime Database
The Firebase Realtime Database is a cloud-hosted database. Data is stored as
JSON and synchronized in realtime to every connected client. When you build
cross-platform apps with our Apple platforms, Android, and JavaScript SDKs,
all of your clients share one Realtime Database instance and automatically
receive updates with the newest data.

Realtime:
Instead of typical HTTP requests, the Firebase Realtime Database uses data
synchronization—every time data changes, any connected device receives that
update within milliseconds. Provide collaborative and immersive experiences
without thinking about networking code.

Offline:
Firebase apps remain responsive even when offline because the Firebase
Realtime Database SDK persists your data to disk. Once connectivity is
reestablished, the client device receives any changes it missed, synchronizing
it with the current server state.
 */
class FirebaseProvider
{
  //Reference to database
  DatabaseReference rootRef =
  FirebaseDatabase.instance.ref('https://befriended-97276-default-rtdb.firebaseio.com/');

  /*
  The DatabaseReference listens for DatabaseEvents at the given path. These
  events are triggered every time the data in the path changes. When triggered,
  the events will store the most up to date data inside a "snapshot" object.
   */

  Object? getJsonObjFrom(String path) {
    final ref = FirebaseDatabase.instance.ref(path);
    late DataSnapshot data;
    ref.onValue.listen((DatabaseEvent event) {
      data = event.snapshot;
    });

    return data.value;
  }

  //NOTE: will replace any existing data at the path
  Future<void> setJsonData(String path, Map<String, Object> data) async {
    final ref = FirebaseDatabase.instance.ref(path);
    await ref.set(data);
  }
}
