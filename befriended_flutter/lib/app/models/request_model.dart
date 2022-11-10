
import 'package:befriended_flutter/app/models/user_model.dart';

import 'chip_model.dart';

class Request
{
    Request(UserModel requester)
    {
      name = requester.name;
      topics = requester.getSelectedTopics();
    }

    //The requester and the topics they want to discuss
    late final UserModel requester;
    late String name;
    late List<ChipModel> topics;
}
