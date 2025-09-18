import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalDetailsScreen extends StatelessWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C5C64), // Burgundy color
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

                  // Personal Details Button - Exact design match
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Optional: Show edit form or additional functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C5C64),
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

                  // Personal Details Display - Exact design match
                  Container(
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
                          "Soham",
                        ),

                        const SizedBox(height: 20),

                        _buildDetailRow(
                          Icons.person_outline,
                          "Last Name :",
                          "Thummar",
                        ),

                        const SizedBox(height: 20),

                        _buildDetailRow(
                          Icons.email_outlined,
                          "Email address :",
                          "sthummar444@rku.ac.in",
                        ),

                        const SizedBox(height: 20),

                        _buildDetailRow(
                          Icons.lock_outline,
                          "Password :",
                          "Luminous2025",
                        ),

                        const SizedBox(height: 24),

                        // Logout Button - Exact design match
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _showLogoutDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFFDC3545,
                              ), // Red color
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

          // Bottom Navigation - Exact match
          Container(
            decoration: const BoxDecoration(color: Color(0xFF9C5C64)),
            child: BottomNavigationBar(
              backgroundColor: const Color(0xFF9C5C64),
              type: BottomNavigationBarType.fixed,
              currentIndex: 2, // Account is selected
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 0,
              onTap: (index) {
                if (index == 1) {
                  // Go back to home - pop twice to get back to home from account settings
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } else if (index == 2) {
                  Navigator.of(context).pop(); // Go back to account user screen
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
                  icon: Icon(Icons.person, size: 28),
                  label: '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        // Icon circle - Exact design match
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF9C5C64).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Icon(icon, color: const Color(0xFF9C5C64), size: 20),
          ),
        ),

        const SizedBox(width: 16),

        // Label and value - Exact design match
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
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF333333),
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
                // Navigate to login and clear all previous routes
                Get.offAllNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC3545),
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
