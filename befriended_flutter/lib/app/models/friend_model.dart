import 'package:befriended_flutter/app/models/user_model.dart';

class Friend
{
  Friend({required this.user})
  {
    name = user.name;
  }
  late UserModel user;
  late String name;
}
