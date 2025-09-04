import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'core/app_theme.dart'; // ✅ added import

void main() {
  runApp(const WaitMedApp());
}

class WaitMedApp extends StatelessWidget {
  const WaitMedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WaitMed",
      theme: AppTheme.lightTheme, // ✅ using theme from app_theme.dart
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/forgot', page: () => const ForgotPasswordScreen()),
      ],
    );
  }
}
