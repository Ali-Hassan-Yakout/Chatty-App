import 'package:chatty/providers/authentication_provider.dart';
import 'package:chatty/utils/app_navigation.dart';
import 'package:chatty/widgets/custom_elevatedbutton.dart';
import 'package:chatty/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthenticationProvider authenticationProvider;
  late AppNavigation appNav;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authenticationProvider = Provider.of<AuthenticationProvider>(context);
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/chatty_splash.png',
                    fit: BoxFit.contain,
                  ),
                ),
                CustomTextFormField(
                  onSaved: (value) {
                    setState(() {
                      emailController.text = value;
                    });
                  },
                  regEx:
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  hintText: "Email",
                  obscureText: false,
                  chat: false,
                ),
                SizedBox(height: 30.h),
                CustomTextFormField(
                  onSaved: (value) {
                    setState(() {
                      passwordController.text = value;
                    });
                  },
                  regEx: r".{8,}",
                  hintText: "Password",
                  obscureText: true,
                  chat: false,
                ),
                SizedBox(height: 30.h),
                CustomElevatedButton(
                  name: "Login",
                  height: 50.h,
                  width: double.infinity,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      authenticationProvider.login(
                        emailController.text,
                        passwordController.text,
                      );
                    }
                  },
                ),
                SizedBox(height: 30.h),
                TextButton(
                  onPressed: () {
                    appNav.navigateToRoute('/register');
                  },
                  child: Text(
                    "Don't Have an account?",
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
