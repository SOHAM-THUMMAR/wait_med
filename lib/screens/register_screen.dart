import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
              const Text("Let’s help you meet up your tasks."),
              const SizedBox(height: 20),
              CustomTextField(hint: "Enter your full name", controller: nameCtrl),
              const SizedBox(height: 20),
              CustomTextField(hint: "Enter your email", controller: emailCtrl),
              const SizedBox(height: 20),
              CustomTextField(hint: "Enter your password", controller: passCtrl, obscure: true),
              const SizedBox(height: 20),
              CustomTextField(hint: "Confirm your password", controller: confirmCtrl, obscure: true),
              const SizedBox(height: 20),
              
              // ✅ Correct button
              CustomButton(
                text: "Register",
                onPressed: () async {
                  if (passCtrl.text != confirmCtrl.text) {
                    Get.snackbar("Error", "Passwords do not match");
                    return;
                  }

                  try {
                    await FirebaseFirestore.instance.collection("users").add({
                      "name": nameCtrl.text.trim(),
                      "email": emailCtrl.text.trim(),
                      "password": passCtrl.text.trim(), // ⚠️ only for testing
                      "createdAt": Timestamp.now(),
                    });

                    Get.snackbar("Success", "Account created successfully");
                    Get.toNamed('/login');
                  } catch (e) {
                    Get.snackbar("Error", e.toString());
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
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
