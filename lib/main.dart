import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/account_settings_screen.dart';
import 'screens/personal_details_screen.dart';
import 'screens/map_screen.dart';
import 'screens/edit_profile_screen.dart';

import 'core/app_theme.dart';
import 'Controller/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register AuthController globally
  Get.put(AuthController());

  runApp(const WaitMedApp());
}

class WaitMedApp extends StatelessWidget {
  const WaitMedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WaitMed",
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/forgot', page: () => const ForgotPasswordScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/account', page: () => const AccountSettingsScreen()),
        GetPage(name: '/personal', page: () => const EditProfileScreen()),
        GetPage(name: '/map', page: () => const OpenStreetMapScreen()),
      ],
    );
  }
}
