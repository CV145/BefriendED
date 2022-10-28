import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/availability_schedule/cubit/timezone.dart';
import 'package:befriended_flutter/app/buddy_request/cubit/request_buddy.dart';
import 'package:befriended_flutter/app/support/cubit/request.dart';
import 'package:befriended_flutter/app/widget/snack_bar.dart';
import 'package:befriended_flutter/firebase/firestore_constants.dart';
import 'package:befriended_flutter/models/user_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirebaseProvider with ChangeNotifier {
  factory FirebaseProvider() {
    return _singleton;
  }

  FirebaseProvider._internal();

  static final FirebaseProvider _singleton = FirebaseProvider._internal();

  final firebaseAuth = FirebaseAuth.instance;
  String? verificationId;
  ConfirmationResult? confirmationResult;
  final firebaseFirestore = FirebaseFirestore.instance;
  final _realtimeDatabase = FirebaseDatabase.instance;
  final _storage = FirebaseStorage.instance;

  bool isLoggedIn() {
    return firebaseAuth.currentUser?.uid != null;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> verifyPhone(
      String mobileNumber, BuildContext context, Function callBack) async {
    try {
      if (kIsWeb) {
        confirmationResult =
            await firebaseAuth.signInWithPhoneNumber(mobileNumber);
        callBack();
      } else {
        await firebaseAuth.verifyPhoneNumber(
          phoneNumber: mobileNumber,
          verificationCompleted: (PhoneAuthCredential credential) {
            log('---------- verified ------------');
          },
          verificationFailed: (FirebaseAuthException e) {
            log('---------- failed ------------');
            handleError(e, context);
            log(e.message ?? '');
            log(e.code);
            // snack bar for valid phone number
          },
          codeSent: (String verificationId, int? resendToken) {
            log('---------- sent ------------');
            ScaffoldMessenger.of(context).showSnackBar(
              singleLineSnackBar(context, 'OTP sent !'),
            );
            this.verificationId = verificationId;
            callBack();
            // Navigate to OTP screen with verificationId
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            log('---------- timeout ------------');
            this.verificationId = verificationId;
          },
        );
      }
    } catch (e) {
      log('%%%%%%%%% error %%%%%%%%%');
      log(e.toString());
      handleError(e as FirebaseException, context);
    }
  }

  Future<void> verifyOTP(
      String otp, BuildContext context, Function(UserChat) callBack) async {
    log(verificationId ?? '');
    log(otp);
    try {
      if (kIsWeb) {
        final userCredential = await confirmationResult!.confirm(otp);
        log('+++++++++signedIn++++++++');
        log(userCredential.toString());
        log(userCredential.user?.uid ?? '');
        log(firebaseAuth.currentUser?.uid ?? '');
        if (userCredential.user != null) {
          await addUser(userCredential.user!, context).then((userChat) {
            callBack(userChat);
          });
          // getUser(value.user!).then<void>((userChat) => callBack(userChat));
        }
      } else {
        final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId ?? '',
          smsCode: otp,
        );

        await firebaseAuth.signInWithCredential(credential).then(
          (value) {
            log('+++++++++signedIn++++++++');
            log(value.toString());
            log(value.user?.uid ?? '');
            log(firebaseAuth.currentUser?.uid ?? '');
            if (value.user != null) {
              addUser(value.user!, context).then((userChat) {
                callBack(userChat);
              });
              // getUser(value.user!).then<void>((userChat) => callBack(userChat));
            }
          },
          onError: (dynamic e) {
            log('+++++++++++++++++');
            log(e.toString());
            log(e.code.toString());
            handleError(e as FirebaseException, context);
          },
        );
      }
    } catch (e) {
      log('##### error ######');
      log(e.toString());
      handleError(e as FirebaseException, context);
    }
  }

  // Future<UserChat> getUser(User user) async {
  //   final QuerySnapshot result = await _firebaseFirestore
  //       .collection(FirestoreConstants.pathUserCollection)
  //       .where(FirestoreConstants.id, isEqualTo: user.uid)
  //       .get();
  //   final List<DocumentSnapshot> documents = result.docs;
  //   final documentSnapshot = documents[0];
  //   final userChat = UserChat.fromDocument(documentSnapshot);
  //   return userChat;
  // }

  Future<UserChat> addUser(User user, BuildContext context) async {
    final appState = context.read<AppCubit>().state;
    final QuerySnapshot result = await firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .where(FirestoreConstants.id, isEqualTo: user.uid)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    final UserChat? userChat;
    if (documents.isEmpty) {
      // Writing data to server because here is a new user
      final userData = {
        FirestoreConstants.name: appState.name,
        FirestoreConstants.phoneNumber: appState.phoneNumber,
        FirestoreConstants.countryCode: appState.countryCode,
        FirestoreConstants.id: user.uid,
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        FirestoreConstants.chattingWith: null,
      };
      await firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(user.uid)
          .set(
            userData,
          );

      userChat = UserChat(
        id: FirestoreConstants.id,
        phoneNumber: FirestoreConstants.phoneNumber,
        name: FirestoreConstants.name,
        countryCode: FirestoreConstants.countryCode,
      );

      // Write data to local storage
      // User? currentUser = user;
      // await prefs.setString(FirestoreConstants.id, currentUser.uid);
      // await prefs.setString(FirestoreConstants.nickname, currentUser.displayName ?? '');
      // await prefs.setString(FirestoreConstants.photoUrl, currentUser.photoURL ?? '');
    } else {
      // Already sign up, just get data from firestore
      // DocumentSnapshot documentSnapshot = documents[0];
      // UserChat userChat = UserChat.fromDocument(documentSnapshot);
      // Write data to local
      // await prefs.setString(FirestoreConstants.id, userChat.id);
      // await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
      // await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
      // await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
      final QuerySnapshot result = await firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .where(FirestoreConstants.id, isEqualTo: user.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      final documentSnapshot = documents[0];
      userChat = UserChat.fromDocument(documentSnapshot);
    }
    // _status = Status.authenticated;
    // notifyListeners();
    // return true;
    return userChat;
  }

  void handleError(FirebaseException e, BuildContext context) {
    if (e.code == 'missing-phone-number' || e.code == 'invalid-phone-number') {
      ScaffoldMessenger.of(context).showSnackBar(
        singleLineSnackBar(context, 'Please enter valid phone number'),
      );
    } else if (e.code == 'missing-verification-code' ||
        e.code == 'invalid-verification-code') {
      ScaffoldMessenger.of(context).showSnackBar(
        singleLineSnackBar(context, 'Please enter valid OTP'),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        singleLineSnackBar(context, 'Error code: ${e.code}'),
      );
    }
  }

  String? getCurrentUserId() {
    final user = firebaseAuth.currentUser;
    return user?.uid;
  }

  Future<void> saveAvailability(
    TimezoneModel timezoneModel,
    List<List<int>> timeMatrix,
  ) async {
    final userId = getCurrentUserId();
    if (userId != null) {
      final availabilityData = {
        FirestoreConstants.timezone: timezoneModel.toJson(),
        FirestoreConstants.timematrix: timeMatrix.toString(),
      };
      // TODO handle error
      await firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(userId)
          .update(
            availabilityData,
          );
    }
  }

  Future<void> saveToBeBuddyRequest(String requestDesc) async {
    final userId = getCurrentUserId();
    if (userId != null) {
      final DocumentSnapshot result = await firebaseFirestore
          .collection(FirestoreConstants.pathToBeBuddyCollection)
          .doc(userId)
          .get();
      if (!result.exists) {
        final requestData = {
          FirestoreConstants.description: requestDesc,
          FirestoreConstants.userid: userId,
          FirestoreConstants.isApproved: false,
        };
        // TODO handle error
        await firebaseFirestore
            .collection(FirestoreConstants.pathToBeBuddyCollection)
            .doc(userId)
            .set(
              requestData,
            );
      } else {
        await firebaseFirestore
            .collection(FirestoreConstants.pathToBeBuddyCollection)
            .doc(userId)
            .update({
          FirestoreConstants.description: requestDesc,
        });
      }
    }
  }

  Stream<RequestModel> getRequest() async* {
    final userId = getCurrentUserId();
    if (userId != null) {
      final stream = firebaseFirestore
          .collection(FirestoreConstants.pathToBeBuddyCollection)
          .doc(userId)
          .snapshots();

      await for (DocumentSnapshot doc in stream) {
        if (doc.exists) {
          yield RequestModel.fromDocument(doc);
        }
      }
    }
  }

  Future<void> saveBuddyRequest(
      String requestDesc, EDType requestEdType) async {
    final userId = getCurrentUserId();
    if (userId != null) {
      final DocumentSnapshot result = await firebaseFirestore
          .collection(FirestoreConstants.pathRequestBuddyCollection)
          .doc(userId)
          .get();
      if (!result.exists) {
        final requestData = {
          FirestoreConstants.description: requestDesc,
          FirestoreConstants.userid: userId,
          FirestoreConstants.matchedUserId: null,
          FirestoreConstants.eDType: requestEdType.value,
        };
        // TODO handle error
        await firebaseFirestore
            .collection(FirestoreConstants.pathRequestBuddyCollection)
            .doc(userId)
            .set(
              requestData,
            );
      } else {
        await firebaseFirestore
            .collection(FirestoreConstants.pathRequestBuddyCollection)
            .doc(userId)
            .update({
          FirestoreConstants.description: requestDesc,
          FirestoreConstants.eDType: requestEdType.value,
        });
      }
    }
  }

  Stream<RequestBuddyModel> getBuddyRequest() async* {
    final userId = getCurrentUserId();
    if (userId != null) {
      final stream = firebaseFirestore
          .collection(FirestoreConstants.pathRequestBuddyCollection)
          .doc(userId)
          .snapshots();

      await for (DocumentSnapshot doc in stream) {
        if (doc.exists) {
          yield RequestBuddyModel.fromDocument(doc);
        }
      }
    }
  }

  Future<Map<String, dynamic>?> getAvailability() async {
    final userId = getCurrentUserId();
    if (userId != null) {
      try {
        // TODO handle error
        final snapshot = await firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(userId)
            .get();

        // final List<DocumentSnapshot> documents = result.docs;
        // final documentSnapshot = documents[0];
        // userChat = UserChat.fromDocument(documentSnapshot);
        List<dynamic> timeMatrixJson =
            jsonDecode(snapshot.get(FirestoreConstants.timematrix) as String)
                as List<dynamic>;
        final timeMatrix = _initGridState;
        for (var i = 0; i < timeMatrixJson.length; i++) {
          print(timeMatrixJson[i]);
          print(timeMatrixJson[i].runtimeType);
          final tempList = timeMatrixJson[i] as List;
          for (var j = 0; j < tempList.length; j++) {
            print(tempList[j]);
            print(tempList[j].runtimeType);
            timeMatrix[i][j] = tempList[j] as int;
            if (tempList[j] == 1) {
              print(timeMatrix);
            }
          }
        }

        return {
          FirestoreConstants.timezone: TimezoneModel.fromJson(snapshot
              .get(FirestoreConstants.timezone) as Map<String, dynamic>),
          FirestoreConstants.timematrix: timeMatrix,
        } as Map<String, dynamic>;
      } catch (e) {
        // TODO handle error
      }
    }
    return null;
  }

  Future<void> sendQuickMessage(dynamic message) async {
    final userId = getCurrentUserId();
    if (userId != null) {
      await sendQuickMessageUserId(userId, message);
    }
  }

  Future<void> sendQuickMessageUserId(String userId, dynamic message) async {
    final ref = _realtimeDatabase.ref('quickchat/$userId');
    final itemRef = ref.push();
    await itemRef.set(json.encode(message));
  }

  Future<void> requestQuickMessageMatch(dynamic message) async {
    final userId = getCurrentUserId();
    if (userId != null) {
      final ref = _realtimeDatabase.ref('quickchatrequest/$userId');
      await ref.set({'match': ''});
      sendQuickMessageUserId(userId, message);
    }
  }

  Future<void> stopQuickMessage(dynamic message) async {
    final userId = getCurrentUserId();
    if (userId != null) {
      final ref = _realtimeDatabase.ref('quickchatrequest/$userId');
      await ref.set({'match': ''});
      sendQuickMessageUserId(userId, message);
    }
  }

  Future<String> uploadImage(String path) async {
    final reference = _storage.ref().child("images/");
    final file = File(path);
    //Upload the file to firebase
    await reference.putFile(file);

    // Waits till the file is uploaded then stores the download url
    final result = await reference.getDownloadURL();
    return result;
  }

  DatabaseReference? getQuickChatMessages() {
    final userId = getCurrentUserId();
    if (userId != null) {
      return FirebaseDatabase.instance.ref('quickchat/$userId');
    }
  }

  DatabaseReference? getQuickChatMatch() {
    final userId = getCurrentUserId();
    if (userId != null) {
      return FirebaseDatabase.instance.ref('quickchatrequest/$userId/match');
    }
  }

  Future<void> updatePresence(bool isOnline) async {
    final userId = getCurrentUserId();
    if (userId != null) {
      final ref = _realtimeDatabase.ref('presence/$userId');
      await ref.set({'isOnline': isOnline});
    }
  }

  DatabaseReference? getPresence(String userId) {
    return FirebaseDatabase.instance.ref('presence/$userId');
  }
}

List<List<int>> _initGridState = [
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
];
