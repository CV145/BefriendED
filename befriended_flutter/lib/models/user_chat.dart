import 'package:befriended_flutter/firebase/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserChat {
  UserChat({
    required this.id,
    required this.phoneNumber,
    required this.name,
    required this.countryCode,
  });

  factory UserChat.fromDocument(DocumentSnapshot doc) {
    var name = '';
    var phoneNumber = '';
    var countryCode = '';
    try {
      name = doc.get(FirestoreConstants.name) as String;
    } catch (e) {}
    try {
      phoneNumber = doc.get(FirestoreConstants.phoneNumber) as String;
    } catch (e) {}
    try {
      countryCode = doc.get(FirestoreConstants.countryCode) as String;
    } catch (e) {}
    return UserChat(
      id: doc.id,
      name: name,
      phoneNumber: phoneNumber,
      countryCode: countryCode,
    );
  }

  String id;
  String phoneNumber;
  String name;
  String countryCode;

  Map<String, String> toJson() {
    return {
      FirestoreConstants.name: name,
      FirestoreConstants.phoneNumber: phoneNumber,
      FirestoreConstants.countryCode: countryCode,
      FirestoreConstants.id: id,
    };
  }
}
