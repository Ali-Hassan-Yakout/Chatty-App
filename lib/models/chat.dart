import 'package:chatty/models/app_user.dart';
import 'package:chatty/models/message.dart';

class Chat {
  final String uid;
  final String currentUserUid;
  final bool isActivity;
  final bool isGroup;
  final List<AppUser> members;
  List<Message> messages;
  late final List<AppUser> recipients;

  Chat({
    required this.uid,
    required this.currentUserUid,
    required this.messages,
    required this.isActivity,
    required this.isGroup,
    required this.members,
  }) {
    recipients = members
        .where(
          (element) => element.uid != currentUserUid,
        )
        .toList();
  }


  List<AppUser> chatRecipients() {
    return recipients;
  }

  String chatTitle() {
    return !isGroup
        ? recipients.first.name
        : recipients.map((user) => user.name).join(", ");
  }

  String chatImageURL() {
    return !isGroup ? recipients.first.imageURL : "";
  }
}
