import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final resetCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            const Text(
              "Reset Password!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CustomTextField(hint: "Enter your email", controller: emailCtrl),
            CustomTextField(hint: "Reset Password", controller: resetCtrl, obscure: true),
            CustomTextField(hint: "Confirm Password", controller: confirmCtrl, obscure: true),
            const SizedBox(height: 20),
            CustomButton(text: "Change Password", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
