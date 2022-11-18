import 'package:flutter/material.dart';


class Request
{
    Request({required String requesterID, required String requesterName,
      required List<String> givenTopics,})
    {
      userID = requesterID;
      name = requesterName;
      topics = givenTopics;

      //Note to self: always initialize a list... even if empty, save debug hrs
      topicChips = [];

      for (final topic in topics) {
        final newChip = Chip(
            label: Text(topic),
            backgroundColor: Colors.white70,
            labelPadding: const EdgeInsets.all(10),
        );
        topicChips.add(newChip);
      }
    }

    //The requester and the topics they want to discuss
    late String name;
    late String userID;
    late List<String> topics;
    late List<Chip> topicChips;
}
