import 'package:chatty/models/app_user.dart';
import 'package:chatty/utils/app_cloud_database.dart';
import 'package:chatty/utils/app_navigation.dart';
import 'package:chatty/utils/app_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:toastification/toastification.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth fireAuth;
  late final AppNavigation appNav;
  late final AppCloudDatabase appDatabase;
  late AppUser appUser;

  AuthenticationProvider() {
    fireAuth = FirebaseAuth.instance;
    appNav = GetIt.instance.get<AppNavigation>();
    appDatabase = GetIt.instance.get<AppCloudDatabase>();
    fireAuth.authStateChanges().listen((user) async {
      if (user != null) {
        await appDatabase.updateLastActive(user.uid);
        await appDatabase.getUser(user.uid).then(
          (snapshot) {
            Map<String, dynamic> userData =
                snapshot.data()! as Map<String, dynamic>;
            appUser = AppUser.fromJson(
              {
                'uid': user.uid,
                'name': userData['name'],
                'email': userData['email'],
                'imageURL': userData['imageURL'],
                'lastActive': userData['lastActive']
              },
            );
            appNav.removeAndNavigateToRoute('/home');
          },
        );
      } else {
        appNav.removeAndNavigateToRoute('/login');
      }
      FlutterNativeSplash.remove();
    });
  }

  Future<void> login(String email, String password) async {
    try {
      await fireAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppToast.displayToast(
        title: "Success",
        description: "You are now logged in.",
        type: ToastificationType.success,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is badly formatted.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'No account found for this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Try again later.';
          break;
        case 'network-request-failed':
          errorMessage = 'No internet connection.';
          break;
        default:
          errorMessage = 'Unexpected error: ${e.code}';
      }

      AppToast.displayToast(
        title: "Login Failed",
        description: errorMessage,
        type: ToastificationType.error,
      );
    } catch (e) {
      AppToast.displayToast(
        title: "Error",
        description: "Something went wrong. Please try again.",
        type: ToastificationType.error,
      );
    }
  }

  Future<String?> register(String email, String password) async {
    try {
      UserCredential credentials =
          await fireAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credentials.user!.uid;
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is badly formatted.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        case 'network-request-failed':
          errorMessage = 'No internet connection.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Try again later.';
          break;
        default:
          errorMessage = 'Unexpected error: ${e.code}';
      }

      AppToast.displayToast(
        title: "Registration Failed",
        description: errorMessage,
        type: ToastificationType.error,
      );
    } catch (e) {
      AppToast.displayToast(
        title: "Error",
        description: "Something went wrong. Please try again.",
        type: ToastificationType.error,
      );
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await fireAuth.signOut();
    } catch (e) {
      AppToast.displayToast(
        title: "Error",
        description: "Something went wrong. Please try again.",
        type: ToastificationType.error,
      );
    }
  }
}
