import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/app_theme.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../Controller/auth_controller.dart';
import 'edit_profile_screen.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../core/app_theme.dart';
// import '../widgets/bottom_navigation_bar.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  int _selectedIndex = 2; // Account tab is selected
  final AuthController _authController = Get.find<AuthController>();

  bool _isLoading = true;
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';
  late final StreamSubscription _userSub;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Add this: Location icon pressed -> Go to Map Screen
      Get.toNamed('/map');
    } else if (index == 1) {
      // Navigate back to Home
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else if (index == 2) {
      Navigator.of(context).pop(); // Go back to Account user screen
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // listen to controller updates so UI refreshes when login sets the user
    _userSub = _authController.rxUser.listen((u) {
      if (u != null) {
        _applyUserToState(u.name, u.email, u.password);
      }
    });
  }

  @override
  void dispose() {
    _userSub.cancel();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      // Try to get from AuthController first
      final user = _authController.currentUser;

      if (user != null) {
        _applyUserToState(user.name, user.email, user.password);
      } else {
        // Fallback: try Firestore using FirebaseAuth current user
        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser == null) {
          // Not logged in
          setState(() {
            _firstName = '';
            _lastName = '';
            _email = '';
            _password = '';
            _isLoading = false;
          });
          return;
        }

        final uid = firebaseUser.uid;
        final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (doc.exists) {
          final fetchedUser = UserModel.fromFirestore(doc);
          // Update controller so other screens can use it
          _authController.setUser(fetchedUser);
          _applyUserToState(fetchedUser.name, fetchedUser.email, fetchedUser.password);
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      // ignore errors for now; you can log or show snackbar
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyUserToState(String name, String email, String password) {
    final parts = name.trim().split(RegExp(r"\s+"));
    final first = parts.isNotEmpty ? parts.first : '';
    final last = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    setState(() {
      _firstName = first;
      _lastName = last;
      _email = email;
      _password = password;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor, // Use theme color
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor, // Use theme color
        title: const Text(
          "Account Settings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Personal Details Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Open edit profile screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Personal Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Personal Details Display
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          Icons.person_outline,
                          "First Name :",
                          _firstName.isNotEmpty ? _firstName : 'N/A',
                        ),
                        const SizedBox(height: 20),
                        _buildDetailRow(
                          Icons.person_outline,
                          "Last Name :",
                          _lastName.isNotEmpty ? _lastName : 'N/A',
                        ),
                        const SizedBox(height: 20),
                        _buildDetailRow(
                          Icons.email_outlined,
                          "Email address :",
                          _email.isNotEmpty ? _email : 'N/A',
                        ),
                        const SizedBox(height: 20),
                        _buildDetailRow(
                          Icons.lock_outline,
                          "Password :",
                          _password.isNotEmpty ? '●●●●●●' : 'Not set',
                        ),

                        const SizedBox(height: 24),

                        // Logout Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _showLogoutDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.errorColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        // Icon circle
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
        ),
        const SizedBox(width: 16),
        // Label and value
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Logout",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color(0xFF666666)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.offAllNamed('/login'); // Clear all routes
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}