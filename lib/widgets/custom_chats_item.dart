import 'package:chatty/widgets/custom_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomChatsItem extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isGroup;
  final bool isActivity;
  final Function onTap;

  const CustomChatsItem({
    super.key,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isActive,
    required this.isActivity,
    required this.onTap,
    required this.isGroup,
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
      subtitle: isActivity
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpinKitThreeBounce(
                  color: Colors.white54,
                  size: 17.r,
                ),
              ],
            )
          : Text(
              subtitle,
              style: TextStyle(
                fontSize: 17.sp,
                color: Colors.white54,
              ),
            ),
      leading: CustomProfileImageWithStatus(
        imagePath: imagePath,
        isActive: isActive,
        isGroup: isGroup,
      ),
    );
  }
}
