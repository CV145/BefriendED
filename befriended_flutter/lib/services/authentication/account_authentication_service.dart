
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountAuthenticationService {
  FirebaseProvider provider = FirebaseProvider();

  Future<String> createNewAccount(String givenEmail, String givenPassword)
  async {
    var error = "There's been an error";
    try {
      final credential =
          await provider.firebaseAuth.createUserWithEmailAndPassword(
          email: givenEmail,
          password: givenPassword,);
      return 'Success';
    }
    on FirebaseAuthException catch(e) {
      error = e.code;

      if (e.code == 'weak-password') {
        error = 'The password provided is too weak';
      }
      else if (e.code == 'email-already-in-use') {
        error = 'An account already exists for that email';
      }
    }
      return error;
    }

    Future<bool> signIn(String givenEmail, String givenPassword)
    async {
      try {
        final credential =
            await provider.firebaseAuth.signInWithEmailAndPassword(
            email: givenEmail,
            password: givenPassword,);
        return true;
      }
      on FirebaseAuthException catch(e)
      {
        if (e.code == 'user-not-found') {
          print('No user found for that email');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user');
        }
      }
      return false;
    }
  }
