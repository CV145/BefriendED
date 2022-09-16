import 'package:befriended_flutter/common/json_map.dart';
import 'package:flutter/material.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'timezone.g.dart';

//timezone model
@immutable
// @JsonSerializable()
class TimezoneModel {
  const TimezoneModel({
    required this.name,
    required this.value,
  });

  factory TimezoneModel.fromJson(JsonMap json) {
    print("+++++++++");
    print(json);
    return TimezoneModel(
      name: json['name'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, String> toJson() {
    return {"name": name, "value": value};
  }

  final String name, value;
}
