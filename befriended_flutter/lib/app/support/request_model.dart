import 'package:befriended_flutter/app/user_profile/chip_model.dart';
import 'package:befriended_flutter/app/user_profile/user_model.dart';

class Request
{
    Request(User requester)
    {
      name = requester.name;
      topics = requester.selectedTopics;
    }

    //The requester and the topics they want to discuss
    late final User requester;
    late String name;
    late List<ChipModel> topics;
}
