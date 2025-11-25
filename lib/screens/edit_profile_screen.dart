import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/app_theme.dart';
import '../widgets/custom_text_field.dart';
import '../Controller/auth_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthController authController = Get.find<AuthController>();

  late TextEditingController _nameCtrl;
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = authController.currentUser;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final uid = authController.currentUserId;
    if (uid == null) {
      Get.snackbar(
        "Error",
        "User not logged in.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final newName = _nameCtrl.text.trim();
    final newPassword = _passwordCtrl.text.trim();

    if (newName.isEmpty) {
      Get.snackbar(
        "Error",
        "Name cannot be empty.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPassword.isNotEmpty && newPassword.length < 6) {
      Get.snackbar(
        "Error",
        "Password must be at least 6 characters long.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid);

      final updateData = {'name': newName};

      if (newPassword.isNotEmpty) {
        updateData['password'] = newPassword;
      }

      // Update Firestore
      await userDocRef.update(updateData);

      // Update local user (name only)
      await authController.updateUserName(newName);

      Get.snackbar(
        "Success",
        "Your details have been updated!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppTheme.primaryColor,
        colorText: Colors.white,
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        "Update Failed",
        "Could not update profile. Error: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          "Edit Personal Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CustomTextField(
                hint: "Full Name",
                controller: _nameCtrl,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                hint: "New Password (Leave blank to keep current)",
                controller: _passwordCtrl,
                obscure: true,
                keyboardType: TextInputType.visiblePassword,
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: _isLoading ? "Saving..." : "Save Changes",
                onPressed: _isLoading ? null : _saveChanges,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const CustomButton({
    required this.text,
    this.onPressed,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppTheme.primaryColor,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
