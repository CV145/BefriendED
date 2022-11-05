
import 'package:befriended_flutter/app/user_profile/user_global_state.dart';
import 'package:befriended_flutter/firebase/firestore_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountAuthenticationService {
  FirestoreProvider provider = FirestoreProvider();

  //Create new account and return new user ID or error
  Future<String?> createNewAccount(String givenName, String givenEmail,
      String givenPassword,)
  async {
    var error = "There's been an error";
    try {
      //Create new account was successful
      final credential =
          await provider.firebaseAuth.createUserWithEmailAndPassword(
          email: givenEmail,
          password: givenPassword,);

      //Create new entry in database for the user
      final userID = credential.user?.uid;
      provider.updateGlobalUser(userID);

      if (userID != null)
      {
        provider.setUserDBData(firestoreID: userID, name: givenName,
            email: givenEmail,);
      }
      else
      {
        return 'Error: UID for new user was null';
      }

      return userID;
    }
    on FirebaseAuthException catch(e) {
      //Error creating new account
      error = e.code;

      if (e.code == 'weak-password') {
        error = 'error: The password provided is too weak';
      }
      else if (e.code == 'email-already-in-use') {
        error = 'error: An account already exists for that email';
      }
    }
      return error;
    }

    Future<String?> signIn(String givenEmail, String givenPassword)
    async {

     var error = 'error signing in';

      try {
        //Login successful - update global user instance
        final credential =
            await provider.firebaseAuth.signInWithEmailAndPassword(
            email: givenEmail,
            password: givenPassword,);
        final userID = credential.user?.uid;
        print('Sign in successful');
        provider.updateGlobalUser(userID);
        print('Newly built user: ${UserGlobalState.loggedInUser.name}');
        return userID;
      }
      on FirebaseAuthException catch(e)
      {
        //Login failed
        if (e.code == 'user-not-found') {
          error = 'error: No user found for that email';
        } else if (e.code == 'wrong-password') {
          error = 'error: Wrong password provided for that user';
        }
      }
      return error;
    }
  }
