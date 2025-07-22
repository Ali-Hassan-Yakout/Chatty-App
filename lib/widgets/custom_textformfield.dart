import 'package:chatty/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;
  final bool chat;

  const CustomTextFormField({
    super.key,
    required this.onSaved,
    required this.regEx,
    required this.hintText,
    required this.obscureText,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (value) => onSaved(value!),
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
      ),
      obscureText: obscureText,
      validator: (value) {
        return chat
            ? null
            : RegExp(regEx).hasMatch(value!)
                ? null
                : "Enter a valid value.";
      },
      decoration: InputDecoration(
        fillColor: AppColors.textFormFieldFill,
        filled: true,
        errorStyle: TextStyle(
          fontSize: 16.sp,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white54,
        ),
      ),
    );
  }
}
