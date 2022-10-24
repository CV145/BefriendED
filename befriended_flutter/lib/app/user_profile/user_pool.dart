import 'package:befriended_flutter/app/user_profile/chip_model.dart';
import 'package:befriended_flutter/app/user_profile/user_model.dart';


//Temporary local storage of users
class UserPool
{
  //Hash structure might work but
  //doing list for now
  List<User> pool =
  [
    User(
      givenName: 'Vicky',
      topics: [
        ChipModel(id: '1',
            name: 'Compulsive Eating'),
      ],
    ),
    User(
      givenName: 'Bala',
      topics: [
        ChipModel(id: '1',
            name: 'Depression',),
      ],
    ),
    User(
      givenName: 'John',
      topics: [
        ChipModel(id: '1',
          name: 'Depression',),
      ],
    ),
    User(
      givenName: 'Celine',
      topics: [
        ChipModel(id: '1',
          name: 'General Eating Disorder',),
      ],
    ),
    User(
      givenName: 'Hanifa',
      topics: [
        ChipModel(id: '1',
          name: 'General Eating Disorder',),
      ],
    ),
    User(
      givenName: 'Abbey',
      topics: [
        ChipModel(id: '1',
          name: 'Anorexia',),
      ],
    ),
    User(
      givenName: 'Jia',
      topics: [
        ChipModel(id: '1',
          name: 'Depression',),
      ],
    ),
    User(
      givenName: 'Owen',
      topics: [
        ChipModel(id: '1',
          name: 'Anxiety',),
      ],
    ),
    User(
      givenName: 'Sheldon',
      topics: [
        ChipModel(id: '1',
          name: 'Binge Eating',),
        ChipModel(id: '2',
          name: 'Selective Eating',),
        ChipModel(id: '3',
          name: 'Chronic Fatigue',),
      ],
    ),
    User(
      givenName: 'Thor',
      topics: [
        ChipModel(id: '1',
          name: 'Muscle Dysmorphia',),
      ],
    ),
  ];
}
