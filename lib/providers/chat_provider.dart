import 'dart:async';
import 'dart:io';

import 'package:chatty/models/message.dart';
import 'package:chatty/providers/authentication_provider.dart';
import 'package:chatty/utils/app_cloud_database.dart';
import 'package:chatty/utils/app_cloud_storage.dart';
import 'package:chatty/utils/app_media.dart';
import 'package:chatty/utils/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';
import 'package:toastification/toastification.dart';

import '../utils/app_toast.dart';

class ChatProvider extends ChangeNotifier {
  late AppCloudDatabase _appDatabase;
  late AppCloudStorage _appStorage;
  late AppMedia _appMedia;
  late AppNavigation _appNav;
  late StreamSubscription messagesStream;
  late StreamSubscription keyboardVisibilityStream;
  late KeyboardVisibilityController keyboardVisibilityController;
  final AuthenticationProvider _authenticationProvider;
  final ScrollController _messageListViewController;
  final String _chatId;
  String? _message;
  List<Message>? messages;

  String get message => _message!;

  set message(String value) {
    _message = value;
  }

  @override
  void dispose() {
    messagesStream.cancel();
    keyboardVisibilityStream.cancel();
    super.dispose();
  }

  ChatProvider(
    this._authenticationProvider,
    this._chatId,
    this._messageListViewController,
  ) {
    _appDatabase = GetIt.instance.get<AppCloudDatabase>();
    _appStorage = GetIt.instance.get<AppCloudStorage>();
    _appMedia = GetIt.instance.get<AppMedia>();
    _appNav = GetIt.instance.get<AppNavigation>();
    keyboardVisibilityController = KeyboardVisibilityController();
    listenForMessages();
    listenForKeyboardChanges();
  }

  void listenForMessages() {
    try {
      messagesStream =
          _appDatabase.streamMessagesForChat(_chatId).listen((snapshot) {
        messages = snapshot.docs.map(
          (doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Message.fromJson(data);
          },
        ).toList();
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            if (_messageListViewController.hasClients) {
              _messageListViewController.jumpTo(
                _messageListViewController.position.maxScrollExtent,
              );
            }
          },
        );
      });
    } catch (e) {
      AppToast.displayToast(
        title: "Error",
        description:
            "Something went wrong while getting messages. Please try again.",
        type: ToastificationType.error,
      );
    }
  }

  void listenForKeyboardChanges() {
    keyboardVisibilityStream =
        keyboardVisibilityController.onChange.listen((event) {
      _appDatabase.updateChatData(_chatId, {
        'isActivity': event,
      });
    });
  }

  void deleteChat() {
    _appNav.goBack();
    _appDatabase.deleteChat(_chatId);
  }

  void sendTextMessage() {
    if (_message != null && _message!.isNotEmpty) {
      Message messageToSend = Message(
        content: _message!,
        senderId: _authenticationProvider.appUser.uid,
        sendTime: DateTime.now(),
        type: MessageType.text,
      );
      _appDatabase.addMessageToChat(_chatId, messageToSend);
    }
  }

  Future<void> sendImageMessage() async {
    try {
      File? image = await _appMedia.pickImage();
      if (image != null) {
        String? imageUrl = await _appStorage.uploadChatImage(
          chatID: _chatId,
          uid: _authenticationProvider.appUser.uid,
          image: image,
        );
        Message messageToSend = Message(
          content: imageUrl!,
          senderId: _authenticationProvider.appUser.uid,
          sendTime: DateTime.now(),
          type: MessageType.image,
        );
        _appDatabase.addMessageToChat(_chatId, messageToSend);
      }
    } catch (e) {
      AppToast.displayToast(
        title: "Error",
        description:
            "Something went wrong while sending image message. Please try again.",
        type: ToastificationType.error,
      );
    }
  }
}
