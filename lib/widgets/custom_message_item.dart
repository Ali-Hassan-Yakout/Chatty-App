import 'package:chatty/widgets/custom_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/app_user.dart';
import '../models/message.dart';

class CustomMessageItem extends StatelessWidget {
  final Message message;
  final bool isMine;
  final AppUser sender;

  const CustomMessageItem({
    super.key,
    required this.message,
    required this.isMine,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          !isMine
              ? CircleAvatar(
                  radius: 15.r,
                  child: ClipOval(
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      sender.imageURL,
                      width: 15.w * 2,
                      height: 15.h * 2,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(),
          SizedBox(width: 10.w),
          message.type == MessageType.text
              ? CustomTextMessageBubble(
                  message: message,
                  isMine: isMine,
                )
              : CustomImageMessageBubble(
                  message: message,
                  isMine: isMine,
                ),
        ],
      ),
    );
  }
}
