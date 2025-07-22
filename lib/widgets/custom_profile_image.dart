import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProfileImage extends StatelessWidget {
  final String? imagePath;
  final double size;
  final bool isGroup;
  final bool isLocal;

  const CustomProfileImage({
    super.key,
    required this.imagePath,
    required this.size,
    this.isGroup = false,
    this.isLocal = false,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size.r,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: !isGroup && imagePath != null
          ? (isLocal ? FileImage(File(imagePath!)) : NetworkImage(imagePath!)) as ImageProvider
          : null,
      child: isGroup
          ? Icon(
        Icons.group,
        size: size.r,
        color: Colors.blueGrey,
      )
          : (imagePath == null || imagePath!.isEmpty)
          ? Icon(
        Icons.person,
        size: size.r,
        color: Colors.grey,
      )
          : null,
    );
  }
}

class CustomProfileImageWithStatus extends StatelessWidget {
  final String? imagePath;
  final bool isActive;
  final bool isGroup;
  final bool isLocal;
  final double radius;

  const CustomProfileImageWithStatus({
    super.key,
    required this.imagePath,
    required this.isActive,
    this.isGroup = false,
    this.isLocal = false,
    this.radius = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius.r,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: (!isGroup && imagePath != null && imagePath!.isNotEmpty)
              ? (isLocal ? FileImage(File(imagePath!)) : NetworkImage(imagePath!)) as ImageProvider
              : null,
          child: isGroup
              ? Icon(
            Icons.group,
            size: radius.r,
            color: Colors.blueGrey,
          )
              : (imagePath == null || imagePath!.isEmpty)
              ? Icon(
            Icons.person,
            size: radius.r,
            color: Colors.grey,
          )
              : null,
        ),
        if (!isGroup)
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: isActive ? Colors.green : Colors.red,
              radius: 7.r,
            ),
          ),
      ],
    );
  }
}
