import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  static ToastificationItem displayToast({
    required String title,
    required String description,
    required ToastificationType type,
  }) {
    toastification.dismissAll();
    return toastification.show(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
        ),
      ),
      description: Text(
        description,
        style: TextStyle(
          fontSize: 18.sp,
        ),
      ),
      type: type,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.topCenter,
      showProgressBar: true,
      autoCloseDuration: const Duration(seconds: 5),
    );
  }
}
