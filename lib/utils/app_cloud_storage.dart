import 'dart:io';

import 'package:chatty/utils/app_toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

class AppCloudStorage {
  final SupabaseClient appStorage = Supabase.instance.client;

  Future<String?> uploadUserProfileImage({
    required String uid,
    required File profileImage,
  }) async {
    try {
      final extension = profileImage.path.split('.').last;
      final path = 'images/users/$uid/profile.$extension';
      await appStorage.storage.from('chatty').upload(
            path,
            profileImage,
          );
      return appStorage.storage.from('chatty').getPublicUrl(path);
    } catch (e) {
      AppToast.displayToast(
        title: "Error",
        description:
            "Something went wrong while uploading profile image. Please try again.",
        type: ToastificationType.error,
      );
    }
    return null;
  }

  Future<String?> uploadChatImage({
    required String chatID,
    required String uid,
    required File image,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = image.path.split('.').last;
      final path = 'images/chats/$chatID/$uid.$timestamp.$extension';
      await appStorage.storage.from('chatty').upload(
            path,
            image,
          );
      return appStorage.storage.from('chatty').getPublicUrl(path);
    } catch (e) {
      AppToast.displayToast(
        title: "Error",
        description:
            "Something went wrong while uploading image. Please try again.",
        type: ToastificationType.error,
      );
    }
    return null;
  }

  void deleteChatImage(String chatID, String uid) {
    appStorage.storage.from('chatty').remove(['images/chats/$chatID/$uid']);
  }
}
