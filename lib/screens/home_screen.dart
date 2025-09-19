import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'account_settings_screen.dart';
import '../core/app_theme.dart';
import '../widgets/bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Middle icon is selected initially (Home)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Location icon pressed -> Go to Map Screen
      Get.toNamed('/map');
    } else if (index == 2) {
      // Profile icon pressed -> Go to Account Settings
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
      );
    }
    // index 1 is current screen (Home), so do nothing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor, // Use AppTheme for consistency
      appBar: AppBar(
        title: const Text(
          "Wait-Med",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // Nearby Hospital Section Title
            Text(
              "Nearby Hospital !",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 12),

            // Hospital Info Card (exactly like your mockup)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shree Giriraj Hospital",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "27, Navjyot Park Society, Navjyot Park Main Rd,\n150 Feet Ring Rd - 360005",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Map Placeholder (simple, exactly like mockup)
            GestureDetector(
              onTap: () => Get.toNamed('/map'),
              child: Container(
                width: double.infinity,
                height: 300, // Good height for map space
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light map-like background
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                // Empty placeholder - just like your mockup shows
                child: Container(), // Completely empty, ready for map
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
