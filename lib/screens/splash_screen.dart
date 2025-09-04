import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset("assets/illustration.png", height: 200), // replace with your asset
            const SizedBox(height: 24),
            const Text(
              "Search for non-crowded hospitals/clinics from anywhere",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            CustomButton(
              text: "Get Started",
              onPressed: () => Get.toNamed('/login'),
            ),
          ],
        ),
      ),
    );
  }
}
