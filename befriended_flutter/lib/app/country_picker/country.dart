import 'package:befriended_flutter/common/json_map.dart';
import 'package:flutter/material.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'country.g.dart';

//country model
@immutable
// @JsonSerializable()
class CountryModel {
  const CountryModel({
    required this.name,
    required this.dialCode,
    required this.code,
    required this.flag,
  });

  factory CountryModel.fromJson(JsonMap json) {
    // print(json);
    final flag = CountryModel.getEmojiFlag(json['code'] as String);
    return CountryModel(
      name: json['name'] as String,
      dialCode: json['dial_code'] as String,
      code: json['code'] as String,
      flag: flag,
    );
  }

  final String name, dialCode, code, flag;

  //Converting country code into emoji flag
  static String getEmojiFlag(String emojiString) {
    const flagOffset = 0x1F1E6;
    const asciiOffset = 0x41;

    final firstChar = emojiString.codeUnitAt(0) - asciiOffset + flagOffset;
    final secondChar = emojiString.codeUnitAt(1) - asciiOffset + flagOffset;

    return String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
  }
}
