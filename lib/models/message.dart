import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  text,
  image,
  unknown,
}

class Message {
  final String content;
  final String senderId;
  final DateTime sendTime;
  final MessageType type;

  Message({
    required this.content,
    required this.senderId,
    required this.sendTime,
    required this.type,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    MessageType messageType;
    switch (json['type']) {
      case "text":
        messageType = MessageType.text;
        break;
      case "image":
        messageType = MessageType.image;
        break;
      default:
        messageType = MessageType.unknown;
    }
    return Message(
      content: json['content'],
      senderId: json['senderId'],
      sendTime: json['sendTime'].toDate(),
      type: messageType,
    );
  }

  Map<String, dynamic> toMap() {
    String messageType;
    switch (type) {
      case MessageType.text:
        messageType = "text";
        break;
      case MessageType.image:
        messageType = "image";
        break;
      default:
        messageType = "unknown";
    }
    return {
      'content': content,
      'senderId': senderId,
      'sendTime': Timestamp.fromDate(sendTime),
      'type': messageType,
    };
  }
}
