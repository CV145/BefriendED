import 'package:befriended_flutter/app/models/user_model.dart';

/*
 Store the info of the user that's logged in here
 */

class UserGlobalState
{
  //Will default to null values
  static UserModel loggedInUser = UserModel(firestoreUid: 'null',
      givenName: 'error: no user', givenTopics: [],);
}
