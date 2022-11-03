import 'package:befriended_flutter/app/user_profile/user_model.dart';

class ChatMessage {
   ChatMessage(UserModel sender, this.message)
  {
    senderName = sender.name;
  }

  late final String senderName;
  final String message;
}
