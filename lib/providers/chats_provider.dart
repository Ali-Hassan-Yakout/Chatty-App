import 'dart:async';

import 'package:chatty/models/app_user.dart';
import 'package:chatty/models/chat.dart';
import 'package:chatty/models/message.dart';
import 'package:chatty/providers/authentication_provider.dart';
import 'package:chatty/utils/app_cloud_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:toastification/toastification.dart';

import '../utils/app_toast.dart';

class ChatsProvider extends ChangeNotifier {
  AuthenticationProvider authenticationProvider;
  late AppCloudDatabase appDatabase;
  List<Chat>? chats;
  late StreamSubscription chatsStream;

  ChatsProvider(this.authenticationProvider) {
    appDatabase = GetIt.instance.get<AppCloudDatabase>();
    getChats();
  }

  @override
  void dispose() {
    chatsStream.cancel();
    super.dispose();
  }

  void getChats() {
    try {
      chatsStream = appDatabase
          .getChats(authenticationProvider.appUser.uid)
          .listen((snapShot) async {
        chats = await Future.wait(
          snapShot.docs.map(
            (doc) async {
              Map<String, dynamic> chatData =
                  doc.data() as Map<String, dynamic>;
              List<AppUser> members = [];
              for (var uid in chatData['members']) {
                DocumentSnapshot userSnapShot = await appDatabase.getUser(uid);
                Map<String, dynamic> userData =
                    userSnapShot.data() as Map<String, dynamic>;
                userData['uid'] = uid;
                members.add(AppUser.fromJson(userData));
              }
              List<Message> messages = [];
              QuerySnapshot chatMessage =
                  await appDatabase.getLastMessage(doc.id);
              if (chatMessage.docs.isNotEmpty) {
                Map<String, dynamic> messageData =
                    chatMessage.docs.first.data()! as Map<String, dynamic>;
                Message message = Message.fromJson(messageData);
                messages.add(message);
              }
              return Chat(
                uid: doc.id,
                currentUserUid: authenticationProvider.appUser.uid,
                messages: messages,
                isActivity: chatData['isActivity'],
                isGroup: chatData['isGroup'],
                members: members,
              );
            },
          ).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      AppToast.displayToast(
        title: "Error",
        description:
            "Something went wrong while getting chats. Please try again.",
        type: ToastificationType.error,
      );
    }
  }
}
