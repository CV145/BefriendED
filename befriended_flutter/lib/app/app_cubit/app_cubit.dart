import 'package:befriended_flutter/app/user_profile/chip_model.dart';
import 'package:befriended_flutter/app/user_profile/user_model.dart';
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:befriended_flutter/local_storage/local_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({required this.localStorage}) : super(const AppState());

  final LocalStorage localStorage;
  FirebaseProvider provider = FirebaseProvider();

  //Emit or "update" to new state = to copy of current state with
  //the new email, trimmed for whitespace
  void emailChanged(String givenEmail)
  => emit(state.copyWith(userEmail: givenEmail.trim()));


  void setUser({required String firestoreID, required String name,
    required String email,})
  {
    final userData = <String, dynamic>{
      'uid': firestoreID,
      'name': name,
      'chosenTopics': <String>[],
      'email': email,
    };

    //Initialize cloud firestore database reference
    final db = provider.firebaseFirestore;
    db.collection('registered_users')
        .doc(firestoreID)
    .set(userData);

  }

  User getUser({required String firestoreID})
  {
    Map<String, dynamic> retrievedData;
    var userName = '';
    var chosenTopics = <String>[];

    //Initialize cloud firestore database reference
    final db = provider.firebaseFirestore;
    final DocumentReference docRef =
    db.collection('registered_users').doc(firestoreID);

    //Get user data
    docRef.get().then(
          (DocumentSnapshot doc)
      {
        retrievedData = doc.data() as Map<String, dynamic>;

        //Populate fields
        userName = retrievedData['name'] as String;
        chosenTopics = retrievedData['chosenTopics'] as List<String>;
      },
    );

    final chips = <ChipModel>[];

    var i = 0;
    for(final topic in chosenTopics)
    {
      final newChip = ChipModel(id: '$i', name: topic);
      chips.add(newChip);
      i++;
    }

    //Create new user object and return it
    final user = User(
      givenName: userName,
      firestoreUid: firestoreID,
      topics: chips,
    );
    return user;
  }


  void checkLogIn({required bool preValidation}) {
    emit(
      state.copyWith(
        isLoggedIn: preValidation &&
            (localStorage.getPhoneNumber()?.isNotEmpty ?? false),
      ),
    );
  }
}
