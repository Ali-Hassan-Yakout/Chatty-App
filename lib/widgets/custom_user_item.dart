import 'package:chatty/widgets/custom_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomUserItem extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isSelected;
  final Function onTap;

  const CustomUserItem({
    super.key,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isActive,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      minVerticalPadding: 10.h,
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 17.sp,
          color: Colors.white54,
        ),
      ),
      leading: CustomProfileImageWithStatus(
        imagePath: imagePath,
        isActive: isActive,
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check,
              color: Colors.white,
            )
          : null,
    );
  }
}
