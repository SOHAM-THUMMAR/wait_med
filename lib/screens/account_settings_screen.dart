import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 1. Add this import
import 'personal_details_screen.dart';
import '../core/app_theme.dart';
import '../Controller/auth_controller.dart';
import 'dart:async';
import '../widgets/bottom_navigation_bar.dart';


class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  int _selectedIndex = 2; // Account is selected
  final AuthController _authController = Get.find<AuthController>();
  late final StreamSubscription _userSub;
  String _name = 'N/A';
  String _email = 'N/A';
  bool _isLoading = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // 2. Add this: Location icon pressed -> Go to Map Screen
      Get.toNamed('/map');
    } else if (index == 1) {
      Navigator.of(context).pop(); // Go back to home
    }
    // index 2 is current screen (account), so do nothing
  }

  @override
  void initState() {
    super.initState();
    // initialize from controller if available
    final u = _authController.currentUser;
    if (u != null) {
      _applyUser(u.name, u.email);
    } else {
      _isLoading = false; // no immediate loading of firestore here; personal screen handles fallback
    }

    _userSub = _authController.rxUser.listen((u) {
      if (u != null) {
        _applyUser(u.name, u.email);
      }
    });
  }

  void _applyUser(String name, String email) {
    setState(() {
      _name = name.isNotEmpty ? name : 'N/A';
      _email = email.isNotEmpty ? email : 'N/A';
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _userSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          "Account user",
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

                  Row(
                    children: [
                      // User Avatar
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _isLoading
                                ? const SizedBox(
                                    height: 36,
                                    child: Center(child: CircularProgressIndicator()),
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _email,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Account Settings Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PersonalDetailsScreen(),
                          ),
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
                        "Account Settings",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Past/Recent Searches Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Optional: Show recent searches dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Past / recent searches",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Recent Searches List
                  Column(
                    children: [
                      _buildSearchItem(
                        Icons.location_on,
                        "Wockhardt Hospitals , Rajkot",
                      ),
                      const SizedBox(height: 12),
                      _buildSearchItem(
                        Icons.location_on,
                        "Sterling Hospitals , Rajkot",
                      ),
                      const SizedBox(height: 12),
                      _buildSearchItem(
                        Icons.location_on,
                        "Genesis Multispeciality Hospital , Rajkot",
                      ),
                      const SizedBox(height: 12),
                      _buildSearchItem(
                        Icons.location_on,
                        "Premier Hospital & ICU",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Modular Bottom Navigation
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildSearchItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.textColor),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: AppTheme.textColor),
          ),
        ),
      ],
    );
  }
}
