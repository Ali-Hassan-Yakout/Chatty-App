import 'package:chatty/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchField extends StatelessWidget {
  final Function(String) onEditingComplete;
  final String hintText;
  final bool obscure;
  final TextEditingController controller;
  final IconData? icon;

  const CustomSearchField({
    super.key,
    required this.onEditingComplete,
    required this.hintText,
    required this.obscure,
    required this.controller,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onEditingComplete: () => onEditingComplete(controller.text),
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
      ),
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: AppColors.textFormFieldFill,
        hintStyle: const TextStyle(
          color: Colors.white54,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white54,
        ),
      ),
    );
  }
}
