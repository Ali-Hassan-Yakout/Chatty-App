import 'package:chatty/utils/app_cloud_database.dart';
import 'package:chatty/utils/app_cloud_storage.dart';
import 'package:chatty/utils/app_colors.dart';
import 'package:chatty/utils/app_media.dart';
import 'package:chatty/utils/app_navigation.dart';
import 'package:chatty/utils/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashScreen({
    super.key,
    required this.onInitializationComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _setup().then(
      (_) => widget.onInitializationComplete(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        navigatorKey: AppNavigation.navigatorKey,
        home: Scaffold(
          backgroundColor: AppColors.primaryDark,
          body: Center(
            child: Container(
              width: 400.w,
              height: 400.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage("assets/images/chatty_splash.png"),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBVLjyF7RbhBVDq3GxyVKd-4aEHSEHgGI0",
        appId: "1:364297763348:android:de2a87342a85e0db5c0501",
        messagingSenderId: "364297763348",
        projectId: "chatty-2f40a",
      ),
    );
    await Supabase.initialize(
      url: 'https://mgzrvawwjkgzvkjqtfdc.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1nenJ2YXd3amtnenZranF0ZmRjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk0Mjc3MzEsImV4cCI6MjA2NTAwMzczMX0.Ba29AT5IEUXI9Vwsba-KYwBtaU6wwGfigurBqK9t0qk',
    );
    _registerServices();
  }

  void _registerServices() {
    GetIt.instance.registerSingleton<AppNavigation>(
      AppNavigation(),
    );
    GetIt.instance.registerSingleton<AppMedia>(
      AppMedia(),
    );
    GetIt.instance.registerSingleton<AppCloudStorage>(
      AppCloudStorage(),
    );
    GetIt.instance.registerSingleton<AppCloudDatabase>(
      AppCloudDatabase(),
    );
  }
}
