import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

/*
User model object, represents a profile, uploaded to Firebase
 */
class User {
  var name = '';
  var tags = List.filled(5, '', growable: false);

}

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  List<Item> tags = []; //List of all tags, initially empty
  final GlobalKey<TagsState> _globalKey = GlobalKey<TagsState>();

  @override
  Widget build(BuildContext context) {
    //SafeArea avoids OS interfaces
    return SafeArea(child: Scaffold(body: Padding(
      padding: const EdgeInsets.all(16),
      child: Tags(
          key: _globalKey,
          itemCount: tags.length,
          columns: 6,
          textField: TagsTextField(
            textStyle: const TextStyle(fontSize: 13),
            onSubmitted: (string)
            {
              setState(() {
                tags.add(Item(title: string));
              });
            },
          ),
        //Generate the list of Item tags
        itemBuilder: (index){
          final currentItem = tags[index];
          return ItemTags(
            index: index,
            title: currentItem.title ?? '',
            customData: currentItem.customData,
            textStyle: const TextStyle(fontSize: 13),
            combine: ItemTagsCombine.withTextBefore,
            onPressed: (i) => print(i),
            onLongPressed: (i) => print(i),
            removeButton: ItemTagsRemoveButton(
              onRemoved: ()
                {
                  setState(() {
                    tags.removeAt(index);
                  });
                  return true;
                },
            ),
          );
        },
      ),
    ),
    ),
    );
  }
}



