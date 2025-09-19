// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/app_theme.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Welcome back!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 220,
                width: double.infinity,
                child: Image.asset('assets/images/login_illustration.png', fit: BoxFit.contain),
              ),
              const SizedBox(height: 40),

              CustomTextField(hint: "Enter your email", controller: emailCtrl),
              const SizedBox(height: 16),
              CustomTextField(hint: "Enter your password", controller: passCtrl, obscure: true),
              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Get.toNamed('/forgot'),
                  child: Text("Forgot password?", style: TextStyle(color: AppTheme.primaryColor, fontSize: 14, fontWeight: FontWeight.w500)),
                ),
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: "Login",
                onPressed: () async {
                  final email = emailCtrl.text.trim();
                  final password = passCtrl.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    Get.snackbar("Error", "Please fill all fields", snackPosition: SnackPosition.BOTTOM);
                    return;
                  }

                  try {
                    // ✅ Await Firebase Auth login
                    UserCredential userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    // ✅ Only navigate if login succeeds
                    if (userCred.user != null) {
                      Get.offAllNamed('/home');
                    }
                  } on FirebaseAuthException catch (e) {
                    // ❌ Wrong password / no user
                    Get.snackbar("Login Failed", e.message ?? "Wrong credentials", snackPosition: SnackPosition.BOTTOM);
                  } catch (e) {
                    Get.snackbar("Error", "Something went wrong", snackPosition: SnackPosition.BOTTOM);
                  }
                },
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Color(0xFF666666))),
                  GestureDetector(
                    onTap: () => Get.toNamed('/register'),
                    child: Text("Sign Up", style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
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
