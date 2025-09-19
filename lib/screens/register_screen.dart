// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const Text(
                "Welcome Onboard!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Text("Let's help you meet up your tasks."),
              const SizedBox(height: 20),

              // Name
              CustomTextField(
                hint: "Enter your full name",
                controller: nameCtrl,
              ),
              const SizedBox(height: 20),

              // Email
              CustomTextField(hint: "Enter your email", controller: emailCtrl),
              const SizedBox(height: 20),

              // Password
              CustomTextField(
                hint: "Enter your password",
                controller: passCtrl,
                obscure: true,
              ),
              const SizedBox(height: 20),

              // Confirm Password
              CustomTextField(
                hint: "Confirm your password",
                controller: confirmCtrl,
                obscure: true,
              ),
              const SizedBox(height: 20),

              // Register Button
              CustomButton(
                text: "Register",
                onPressed: () async {
                  final name = nameCtrl.text.trim();
                  final email = emailCtrl.text.trim();
                  final password = passCtrl.text.trim();
                  final confirm = confirmCtrl.text.trim();

                  if (name.isEmpty || email.isEmpty || password.isEmpty) {
                    Get.snackbar(
                      "Error",
                      "All fields are required",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  if (password != confirm) {
                    Get.snackbar(
                      "Error",
                      "Passwords do not match",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  try {
                    // ✅ Add user to Firestore collection "users"
                    await FirebaseFirestore.instance.collection("users").add({
                      "name": name,
                      "email": email,
                      "password": password, // required for Firestore login
                      "createdAt": Timestamp.now(),
                    });

                    Get.snackbar(
                      "Success",
                      "Account created successfully",
                      snackPosition: SnackPosition.BOTTOM,
                    );

                    // Navigate to login
                    Get.toNamed('/login');
                  } catch (e) {
                    Get.snackbar(
                      "Error",
                      "Something went wrong",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),

              const SizedBox(height: 12),

              // Sign In Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => Get.toNamed('/login'),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
