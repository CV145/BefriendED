
import 'package:flutter/material.dart';


class Request
{
    Request({required String requesterID, required String requesterName,
      required List<String> givenTopics,})
    {
      print('inside request constructor');
      userID = requesterID;
      name = requesterName;
      topics = givenTopics;

      //Note to self: always initialize a list... even if empty, save debug hrs
      topicChips = [];

      for (final topic in topics) {
        final newChip = Chip(label: Text(topic));
        topicChips.add(newChip);
      }
    }

    //The requester and the topics they want to discuss
    late String name;
    late String userID;
    late List<String> topics;
    late List<Chip> topicChips;
}
