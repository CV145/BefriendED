
import 'package:befriended_flutter/app/models/chip_model.dart';
import 'package:befriended_flutter/app/models/user_model.dart';

class Request
{
    Request(UserModel requester)
    {
      name = requester.name;
      topics = requester.selectedTopics;
    }

    //The requester and the topics they want to discuss
    late final UserModel requester;
    late String name;
    late List<ChipModel> topics;
}
