import 'dart:core';

import 'package:befriended_flutter/app/user_profile/chip_model.dart';
import 'package:befriended_flutter/app/user_profile/user_model.dart';
import 'package:flutter/material.dart';

/*
'Tags' are what the user can display on their profile to share with others
the kinds of symptoms and topics they would like to talk about. These are
pre-defined so users can just choose like 3-5 of them from this pool
 */

class Tags {
  Tags({required User appUser}) {
    currentUser = appUser;
  }

  //Reference to the current User of the app
  late User currentUser;

  //https://breathelifehealingcenters.com/12-types-eating-disorders-explained/
  final List<String> eatingDisorderTopics = [
    'Anorexia',
    'Binge Eating',
    'Bulimia',
    'Muscle Dysmorphia',
    'General Eating Disorder',
    'Compulsive Eating',
    'Chronic Fatigue',
    'Diabetes',
    'Diabulimia',
    'Orthorexia',
    'Selective Eating',
    'Drunkorexia',
    'Pregorexia',
    'Depression',
    'Anxiety',
  ];
}
