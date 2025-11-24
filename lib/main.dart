import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/account_settings_screen.dart';
import 'screens/personal_details_screen.dart';
import 'screens/map_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/submit_crowd_level_screen.dart';

// Services
import 'services/notification_service.dart';
import 'services/hospital_geofence_service.dart';

// Controllers
import 'Controller/auth_controller.dart';

// Theme
import 'core/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Notification Service
  await NotificationService.initialize();

  // Register Auth Controller
  Get.put(AuthController());

  // Auto-login check
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

  // Start the app
  runApp(WaitMedApp(isLoggedIn: isLoggedIn));

  // Start Hospital Geofencing Service AFTER app starts
  final geofence = HospitalGeofenceService(
    radiusMeters: 200,           // change radius if needed
    queryIntervalSeconds: 20,    // how often to check
  );

  geofence.startMonitoring();
}

class WaitMedApp extends StatelessWidget {
  final bool isLoggedIn;

  const WaitMedApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WaitMed",
      theme: AppTheme.lightTheme,

      // If user already logged in → go directly Home
      // else → show SplashScreen
      home: isLoggedIn ? const HomeScreen() : const SplashScreen(),

      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/forgot', page: () => const ForgotPasswordScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/account', page: () => const AccountSettingsScreen()),
        GetPage(name: '/personal', page: () => const EditProfileScreen()),
        GetPage(name: '/map', page: () => const OpenStreetMapScreen()),

        // Add submit crowd level screen route (optional)
        GetPage(
            name: '/submit',
            page: () => SubmitCrowdLevelScreen(
                  name: Get.arguments['name'],
                  website: Get.arguments['website'],
                  address: Get.arguments['address'],
                  hours: Get.arguments['hours'],
                  latitude: Get.arguments['latitude'],
                  longitude: Get.arguments['longitude'],
                )),
      ],
    );
  }
}
