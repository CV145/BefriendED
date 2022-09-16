import 'package:befriended_flutter/common/json_map.dart';
import 'package:befriended_flutter/firebase/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'country.g.dart';

//country model
@immutable
// @JsonSerializable()
class RequestModel {
  const RequestModel({
    required this.description,
    required this.userid,
    required this.isApproved,
  });

  factory RequestModel.fromDocument(DocumentSnapshot doc) {
    return RequestModel(
      description: doc.get(FirestoreConstants.description) as String,
      userid: doc.get(FirestoreConstants.userid) as String,
      isApproved: doc.get(FirestoreConstants.isApproved) as bool,
    );
  }

  final String description, userid;
  final bool isApproved;
}
