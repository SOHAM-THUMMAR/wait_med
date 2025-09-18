import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'personal_details_screen.dart';
import '../core/app_theme.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor, // Use theme color
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor, // Use theme color
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
                          color: AppTheme.primaryColor, // Use theme color
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
                            Text(
                              "Thummar Soham",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textColor, // Use theme color
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "sthummar444@rku.ac.in",
                              style: TextStyle(
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
                        backgroundColor:
                            AppTheme.primaryColor, // Use theme color
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
                        backgroundColor:
                            AppTheme.primaryColor, // Use theme color
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

          // Bottom Navigation - Using AppTheme
          BottomNavigationBar(
            backgroundColor: AppTheme.primaryColor, // Use theme color
            type: BottomNavigationBarType.fixed,
            currentIndex: 2, // Account is selected
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            onTap: (index) {
              if (index == 1) {
                Navigator.of(context).pop(); // Go back to home
              } else if (index == 0) {
                // Handle location tap if needed
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined, size: 28),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 28),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 28), // Filled for selected
                label: '',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.textColor), // Use theme color
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textColor,
            ), // Use theme color
          ),
        ),
      ],
    );
  }
}
