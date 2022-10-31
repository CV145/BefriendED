
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountAuthenticationService {
  FirebaseProvider provider = FirebaseProvider();

  //Create new account and return new user ID or error
  Future<String?> createNewAccount(String givenEmail, String givenPassword)
  async {
    var error = "There's been an error";
    try {
      final credential =
          await provider.firebaseAuth.createUserWithEmailAndPassword(
          email: givenEmail,
          password: givenPassword,);

      //Create new entry in database for the user
      return credential.user?.uid;
    }
    on FirebaseAuthException catch(e) {
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
        final credential =
            await provider.firebaseAuth.signInWithEmailAndPassword(
            email: givenEmail,
            password: givenPassword,);
        return credential.user?.uid;
      }
      on FirebaseAuthException catch(e)
      {
        if (e.code == 'user-not-found') {
          error = 'error: No user found for that email';
        } else if (e.code == 'wrong-password') {
          error = 'error: Wrong password provided for that user';
        }
      }
      return error;
    }
  }
