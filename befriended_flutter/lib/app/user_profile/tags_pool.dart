import 'dart:core';
import 'package:flutter/material.dart';


/*
'Tags' are what the user can display on their profile to share with others
the kinds of symptoms and topics they would like to talk about. These are
pre-defined so users can just choose like 3-5 of them from this pool
 */

class Tags
{
  Tags()
  {
    chipsList = eatingDisorderTopics.map((topic) => FilterChip(
      label: Text(topic),
      onSelected: (bool value) {  },
    ),).toList();
  }

  //https://breathelifehealingcenters.com/12-types-eating-disorders-explained/
  final List<String> eatingDisorderTopics = [
    'Anorexia', 'Binge Eating', 'Bulimia', 'Muscle Dysmorphia',
    'General Eating Disorder', 'Compulsive Eating', 'Chronic Fatigue',
    'Diabetes', 'Diabulimia', 'Orthorexia', 'Selective Eating', 'Drunkorexia',
    'Pregorexia'
  ];

  //Build a list of Chip Items by instantiating
  late List<FilterChip> chipsList = [];
}

