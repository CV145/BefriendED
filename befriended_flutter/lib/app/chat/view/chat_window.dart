import 'dart:convert';
import 'dart:developer';

import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:bubble/bubble.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatWindowPage extends StatefulWidget {
  const ChatWindowPage({Key? key}) : super(key: key);

  @override
  _ChatWindowPageState createState() => _ChatWindowPageState();
}

class _ChatWindowPageState extends State<ChatWindowPage> {
  List<types.Message> _messages = [];
  late types.User _user;

  @override
  void initState() {
    super.initState();
    _user = types.User(id: FirebaseProvider().getCurrentUserId()!);

    final ref = FirebaseProvider().getQuickChatMatch();
    ref?.onValue.listen((event) {
      final data = event.snapshot.value as String?;
      if (data == null || data.isEmpty) {
        final textMessage = types.TextMessage(
          author: types.User(id: 'admin'),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text:
              'Welcome to buddy chat support, share your concerns soon one of our buddy mentors will connect with you',
        );
        FirebaseProvider().requestQuickMessageMatch(textMessage);
      }
    });
    _loadMessages();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final url = await FirebaseProvider().uploadImage(result.path);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: url,
        width: image.width.toDouble(),
      );

      // _addMessage(message);
      FirebaseProvider().sendQuickMessage(message);
    }
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    // _addMessage(textMessage);
    FirebaseProvider().sendQuickMessage(textMessage);
  }

  void _loadMessages() async {
    // final response = await rootBundle.loadString('assets/messages.json');
    // final messages = (jsonDecode(response) as List)
    //     .map((dynamic e) => types.Message.fromJson(e as Map<String, dynamic>))
    //     .toList();

    final ref = FirebaseProvider().getQuickChatMessages();
    if (ref != null) {
      ref.onChildAdded.listen((event) {
        print('+++++++++');
        inspect(event);
        // A new comment has been added, so add it to the displayed list.
        if (event.snapshot.exists && mounted) {
          setState(() {
            _messages = [
              types.Message.fromJson(
                  json.decode(event.snapshot.value as String? ?? '')
                      as Map<String, dynamic>),
              ..._messages,
            ];
          });
        }
      });
    }
  }

  Widget _bubbleBuilder(
    Widget child, {
    required dynamic message,
    required bool nextMessageInGroup,
  }) {
    if (message.type != types.MessageType.image) {
      return Bubble(
        child: child,
        color: _user.id != message.author.id
            ? const Color(0xfff5f5f7)
            : Theme.of(context).colorScheme.onPrimary,
        margin: nextMessageInGroup
            ? const BubbleEdges.symmetric(horizontal: 6)
            : null,
        radius: Radius.circular(10.0),
        nipRadius: 2,
        nipHeight: 15,
        nip: nextMessageInGroup
            ? BubbleNip.no
            : _user.id != message.author.id
                ? BubbleNip.leftBottom
                : BubbleNip.rightBottom,
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chat(
        messages: _messages,
        onAttachmentPressed: _handleAtachmentPressed,
        onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        user: _user,
        theme: DefaultChatTheme(
          backgroundColor: Theme.of(context).colorScheme.primary,
          inputBackgroundColor: Theme.of(context).colorScheme.onPrimary,
          primaryColor: Theme.of(context).colorScheme.onPrimary,
          messageInsetsHorizontal: 10,
          messageInsetsVertical: 5,
          messageBorderRadius: 10,
          attachmentButtonIcon: Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(
              Icons.add_photo_alternate_outlined,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
