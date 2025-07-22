import 'package:chatty/pages/chats_screen.dart';
import 'package:chatty/pages/home_screen.dart';
import 'package:chatty/pages/login_screen.dart';
import 'package:chatty/pages/register_screen.dart';
import 'package:chatty/pages/users_screen.dart';
import 'package:chatty/providers/authentication_provider.dart';
import 'package:chatty/utils/app_cloud_database.dart';
import 'package:chatty/utils/app_cloud_storage.dart';
import 'package:chatty/utils/app_media.dart';
import 'package:chatty/utils/app_navigation.dart';
import 'package:chatty/utils/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
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
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext context) => AuthenticationProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(
          393,
          851,
        ),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => ToastificationWrapper(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.dark,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            navigatorKey: AppNavigation.navigatorKey,
            initialRoute: '/login',
            routes: {
              '/login': (BuildContext context) => const LoginScreen(),
              '/home': (BuildContext context) => const HomeScreen(),
              '/register': (BuildContext context) => const RegisterScreen(),
              '/chats': (BuildContext context) => const ChatsScreen(),
              '/users': (BuildContext context) => const UsersScreen(),
            },
          ),
        ),
      ),
    );
  }
}
