import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'personal_details_screen.dart';
import '../core/app_theme.dart';
import '../Controller/auth_controller.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../services/search_history_service.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  int _selectedIndex = 2;
  final AuthController _authController = Get.find<AuthController>();
  late final StreamSubscription _userSub;

  String _name = 'N/A';
  String _email = 'N/A';
  bool _isLoading = true;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      Get.toNamed('/map');
    } else if (index == 1) {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();

    final u = _authController.currentUser;
    if (u != null) {
      _applyUser(u.name, u.email);
    } else {
      _isLoading = false;
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

                  // USER INFO
                  Row(
                    children: [
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

                      Expanded(
                        child: _isLoading
                            ? const SizedBox(
                                height: 36,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
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
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ACCOUNT SETTINGS BUTTON
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

                  // RECENT SEARCHES BUTTON (optional)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
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

                  FutureBuilder<List<String>>(
                    future: SearchHistoryService.getSearchHistory(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final searches = snapshot.data!;

                      if (searches.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            "No recent searches",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        );
                      }

                      return Column(
                        children: searches.map((keyword) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildSearchItem(Icons.location_on, keyword),
                          );
                        }).toList(),
                      );
                    },
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
