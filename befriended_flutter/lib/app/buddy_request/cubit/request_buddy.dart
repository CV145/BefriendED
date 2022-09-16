import 'package:befriended_flutter/common/json_map.dart';
import 'package:befriended_flutter/firebase/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'country.g.dart';

enum EDType {
  AnorexiaNervosa, // => 'Anorexia nervosa';
  BulimiaNervosa, // 'Bulimia nervosa'
  BingeEatingDisorder, // 'Binge eating disorder'
  Pica, // 'Pica'
  RuminationDisorder, // 'Rumination disorder'
  ARFID, // 'ARFID'
}

EDType getEDType(String value) {
  switch (value) {
    case 'Anorexia nervosa':
      return EDType.AnorexiaNervosa;
    case 'Bulimia nervosa':
      return EDType.BulimiaNervosa;
    case 'Binge eating disorder':
      return EDType.BingeEatingDisorder;
    case 'Pica':
      return EDType.Pica;
    case 'Rumination disorder':
      return EDType.RuminationDisorder;
    case 'ARFID':
      return EDType.ARFID;
    default:
      return EDType.AnorexiaNervosa;
  }
}

//country model
@immutable
// @JsonSerializable()
class RequestBuddyModel {
  const RequestBuddyModel({
    required this.description,
    required this.userid,
    required this.matchedUserId,
    required this.eDType,
  });

  factory RequestBuddyModel.fromDocument(DocumentSnapshot doc) {
    return RequestBuddyModel(
      description: doc.get(FirestoreConstants.description) as String,
      userid: doc.get(FirestoreConstants.userid) as String,
      matchedUserId: doc.get(FirestoreConstants.matchedUserId) as String?,
      eDType: getEDType(doc.get(FirestoreConstants.eDType) as String),
    );
  }

  final String description, userid;
  final String? matchedUserId;
  final EDType eDType;
}

extension EDTypeExtension on EDType {
  String get value {
    switch (this) {
      case EDType.AnorexiaNervosa:
        return 'Anorexia nervosa';
      case EDType.BulimiaNervosa:
        return 'Bulimia nervosa';
      case EDType.BingeEatingDisorder:
        return 'Binge eating disorder';
      case EDType.Pica:
        return 'Pica';
      case EDType.RuminationDisorder:
        return 'Rumination disorder';
      case EDType.ARFID:
        return 'ARFID';
    }
  }

  bool isEqual(dynamic val) {
    if (val is String) {
      return toString() == val || value == val;
    } else if (val is EDType) {
      return this == val || value == val.value;
    } else {
      return false;
    }
  }
}
