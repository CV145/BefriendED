
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountAuthenticationService {
  FirebaseProvider provider = FirebaseProvider();

  Future<bool> createNewAccount(String givenEmail, String givenPassword)
  async {
    try {
      final credential =
          await provider.firebaseAuth.createUserWithEmailAndPassword(
          email: givenEmail,
          password: givenPassword,);
      return true;
    }
    on FirebaseAuthException catch(e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak');
      }
      else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email');
      }
    }
      catch (e) {
        print(e);
      }

      return false;
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
