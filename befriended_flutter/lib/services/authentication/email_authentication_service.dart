
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthenticationService {
  var emailAuth = 'someemail@domain.com';
  FirebaseProvider provider = FirebaseProvider();

  var acs = ActionCodeSettings(
    url: 'url',
    handleCodeInApp: true,
    iOSBundleId: 'com.example.ios',
    androidPackageName: 'com.example.android',

    //Install if not available
    androidInstallApp: true,

    androidMinimumVersion: '12',
  );

  void sendLinkToEmail(String givenEmail) {
    provider.firebaseAuth.sendSignInLinkToEmail(
      email: givenEmail, actionCodeSettings: acs,);
  }
}
