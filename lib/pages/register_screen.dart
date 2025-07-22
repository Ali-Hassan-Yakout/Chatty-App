import 'dart:io';

import 'package:chatty/utils/app_cloud_database.dart';
import 'package:chatty/utils/app_cloud_storage.dart';
import 'package:chatty/utils/app_media.dart';
import 'package:chatty/utils/app_navigation.dart';
import 'package:chatty/widgets/custom_elevatedbutton.dart';
import 'package:chatty/widgets/custom_profile_image.dart';
import 'package:chatty/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  File? profileImage;

  late AuthenticationProvider authenticationProvider;
  late AppCloudDatabase appDatabase;
  late AppCloudStorage appStorage;
  late AppNavigation appNav;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authenticationProvider = Provider.of<AuthenticationProvider>(context);
    appDatabase = GetIt.instance.get<AppCloudDatabase>();
    appStorage = GetIt.instance.get<AppCloudStorage>();
    appNav = GetIt.instance.get<AppNavigation>();

    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.r),
          child: Form(
            key: formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                SizedBox(height: 50.h),
                GestureDetector(
                  onTap: () async {
                    File? file =
                        await GetIt.instance.get<AppMedia>().pickImage();
                    setState(() {
                      profileImage = file;
                    });
                  },
                  child: CustomProfileImage(
                    imagePath: profileImage?.path,
                    size: 90,
                  ),
                ),
                SizedBox(height: 100.h),
                CustomTextFormField(
                  onSaved: (value) => nameController.text = value,
                  regEx: r".{8,}",
                  hintText: "Name",
                  obscureText: false,
                  chat: false,
                ),
                SizedBox(height: 30.h),
                CustomTextFormField(
                  onSaved: (value) => emailController.text = value,
                  regEx:
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  hintText: "Email",
                  obscureText: false,
                  chat: false,
                ),
                SizedBox(height: 30.h),
                CustomTextFormField(
                  onSaved: (value) => passwordController.text = value,
                  regEx: r".{8,}",
                  hintText: "Password",
                  obscureText: true,
                  chat: false,
                ),
                SizedBox(height: 30.h),
                CustomElevatedButton(
                  name: "Register",
                  height: 50.h,
                  width: double.infinity,
                  onPressed: () async {
                    if (formKey.currentState!.validate() &&
                        profileImage != null) {
                      formKey.currentState!.save();
                      String? uid = await authenticationProvider.register(
                        emailController.text,
                        passwordController.text,
                      );
                      String? imageURL =
                          await appStorage.uploadUserProfileImage(
                        uid: uid!,
                        profileImage: profileImage!,
                      );
                      await appDatabase.saveUserData(
                        uid: uid,
                        email: emailController.text,
                        name: nameController.text,
                        imageURL: imageURL!,
                      );
                      authenticationProvider.logout();
                      authenticationProvider.login(
                        emailController.text,
                        passwordController.text,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
