import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // ------------------------ Firebase Init ------------------------
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ------------------------ Notification Init ------------------------
  await NotificationService.initialize();

  // ------------------------ GetX Controller Init ------------------------
  final auth = Get.put(AuthController());

  // ------------------------ Shared Prefs Login ------------------------
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
  final String? uid = prefs.getString("uid");

  // If UID exists, restore user data from Firestore
  if (uid != null) {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (doc.exists) {
        auth.setUser(UserModel.fromFirestore(doc));
      }
    } catch (e) {
      print("Error restoring user: $e");
    }
  }

  // ------------------------ Run App ------------------------
  runApp(WaitMedApp(isLoggedIn: isLoggedIn));

  // ------------------------ Start Geofencing After App Builds ------------------------
  final geofence = HospitalGeofenceService(
    radiusMeters: 200,
    queryIntervalSeconds: 20,
  );

  geofence.startMonitoring();
}

// ------------------------ APP WIDGET ------------------------
class WaitMedApp extends StatelessWidget {
  final bool isLoggedIn;

  const WaitMedApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WaitMed",
      theme: AppTheme.lightTheme,

      // Auto navigation
      home: isLoggedIn ? const HomeScreen() : const SplashScreen(),

      // App Routes
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/forgot', page: () => const ForgotPasswordScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/account', page: () => const AccountSettingsScreen()),
        GetPage(name: '/personal', page: () => const EditProfileScreen()),
        GetPage(name: '/map', page: () => const OpenStreetMapScreen()),

        // Crowd Level Submit Screen
        GetPage(
          name: '/submit',
          page: () => SubmitCrowdLevelScreen(
            name: Get.arguments['name'],
            website: Get.arguments['website'],
            address: Get.arguments['address'],
            hours: Get.arguments['hours'],
            latitude: Get.arguments['latitude'],
            longitude: Get.arguments['longitude'],
          ),
        ),
      ],
    );
  }
}
