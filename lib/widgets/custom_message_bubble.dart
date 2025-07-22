import 'package:chatty/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../utils/app_colors.dart';

class CustomTextMessageBubble extends StatelessWidget {
  final Message message;
  final bool isMine;

  const CustomTextMessageBubble({
    super.key,
    required this.message,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = isMine
        ? (Theme.of(context).brightness == Brightness.light
        ? AppColors.senderGradientLight
        : AppColors.senderGradientDark)
        : (Theme.of(context).brightness == Brightness.light
        ? AppColors.receiverGradientLight
        : AppColors.receiverGradientDark);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            colors: gradient,
            stops: const [0.30, 0.70],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                height: 1.4,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            SizedBox(height: 8.h),
            Text(
              timeago.format(message.sendTime),
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomImageMessageBubble extends StatelessWidget {
  final Message message;
  final bool isMine;

  const CustomImageMessageBubble({
    super.key,
    required this.message,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = isMine
        ? (Theme.of(context).brightness == Brightness.light
        ? AppColors.senderGradientLight
        : AppColors.senderGradientDark)
        : (Theme.of(context).brightness == Brightness.light
        ? AppColors.receiverGradientLight
        : AppColors.receiverGradientDark);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            colors: gradient,
            stops: const [0.30, 0.70],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                message.content,
                fit: BoxFit.cover,
                width: 200.w,
                height: 250.h,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              timeago.format(message.sendTime),
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
