// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              CustomTextField(hint: "Enter your full name", controller: nameCtrl),
              const SizedBox(height: 20),
              CustomTextField(hint: "Enter your email", controller: emailCtrl),
              const SizedBox(height: 20),
              CustomTextField(hint: "Enter your password", controller: passCtrl, obscure: true),
              const SizedBox(height: 20),
              CustomTextField(hint: "Confirm your password", controller: confirmCtrl, obscure: true),
              const SizedBox(height: 20),
              CustomButton(
                text: "Register",
                onPressed: () async {
                  final name = nameCtrl.text.trim();
                  final email = emailCtrl.text.trim();
                  final password = passCtrl.text.trim();
                  final confirm = confirmCtrl.text.trim();

                  if (name.isEmpty || email.isEmpty || password.isEmpty) {
                    Get.snackbar("Error", "All fields are required", snackPosition: SnackPosition.BOTTOM);
                    return;
                  }

                  if (password != confirm) {
                    Get.snackbar("Error", "Passwords do not match", snackPosition: SnackPosition.BOTTOM);
                    return;
                  }

                  try {
                    // ✅ Create user in Firebase Auth
                    UserCredential userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    // ✅ Save extra info in Firestore
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(userCred.user!.uid)
                        .set({
                      "name": name,
                      "email": email,
                      "createdAt": Timestamp.now(),
                    });

                    Get.snackbar("Success", "Account created successfully", snackPosition: SnackPosition.BOTTOM);
                    Get.toNamed('/login');
                  } on FirebaseAuthException catch (e) {
                    Get.snackbar("Error", e.message ?? "Registration failed", snackPosition: SnackPosition.BOTTOM);
                  }
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => Get.toNamed('/login'),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
