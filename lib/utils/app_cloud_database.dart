import 'package:chatty/models/message.dart';
import 'package:chatty/utils/app_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toastification/toastification.dart';

class AppCloudDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getUser(String uid) async {
    return await firestore.collection('users').doc(uid).get();
  }

  Future<QuerySnapshot> getUsers(String? name) async {
    Query query = firestore.collection('users');
    if (name != null) {
      query = query
          .where('name', isGreaterThanOrEqualTo: name)
          .where('name', isLessThanOrEqualTo: "${name}z");
    }
    return await query.get();
  }

  Future<void> updateLastActive(String uid) async {
    await firestore.collection('users').doc(uid).update({
      'lastActive': DateTime.now().toUtc(),
    });
  }

  Future<void> saveUserData({
    required String uid,
    required String email,
    required String name,
    required String imageURL,
  }) async {
    try {
      firestore.collection('users').doc(uid).set({
        'email': email,
        'name': name,
        'imageURL': imageURL,
        'lastActive': DateTime.now().toUtc(),
      });
    } catch (e) {
      AppToast.displayToast(
        title: "Error",
        description:
            "Something went wrong while saving user data. Please try again.",
        type: ToastificationType.error,
      );
    }
  }

  Stream<QuerySnapshot> getChats(String uid) {
    return firestore
        .collection('chats')
        .where("members", arrayContains: uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessage(String chatId) async {
    return await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sendTime', descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChat(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy(
          'sendTime',
          descending: false,
        )
        .snapshots();
  }

  Future<void> deleteChat(String chatId) async {
    try {
      await firestore.collection('chats').doc(chatId).delete();

    } catch (e) {
      AppToast.displayToast(
        title: "Error",
        description:
            "Something went wrong while deleting chat. Please try again.",
        type: ToastificationType.error,
      );
    }
  }

  Future<void> addMessageToChat(String chatId, Message message) async {
    try {
      await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(
            message.toMap(),
          );
    } catch (e) {
      AppToast.displayToast(
        title: "Error",
        description:
            "Something went wrong while adding message to chat. Please try again.",
        type: ToastificationType.error,
      );
    }
  }

  Future<void> updateChatData(String chatId, Map<String, dynamic> data) async {
    try {
      await firestore.collection('chats').doc(chatId).update(data);
    } catch (e) {
      AppToast.displayToast(
        title: "Error",
        description:
            "Something went wrong while updating chat data. Please try again.",
        type: ToastificationType.error,
      );
    }
  }

  Future<DocumentReference?> createChat(Map<String, dynamic> data) async {
    try {
      return await firestore.collection('chats').add(data);
    } catch (e) {
      AppToast.displayToast(
        title: "Error",
        description:
            "Something went wrong while creating chat. Please try again.",
        type: ToastificationType.error,
      );
    }
    return null;
  }
}
