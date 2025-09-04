import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            const Text(
              "Welcome back!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Image.asset("assets/login_illustration.png", height: 150), // replace with your asset
            const SizedBox(height: 20),
            CustomTextField(hint: "Enter your email", controller: emailCtrl),
            CustomTextField(hint: "Enter your password", controller: passCtrl, obscure: true),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Get.toNamed('/forgot'),
                child: const Text(
                  "Forgot password",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(text: "Login", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
