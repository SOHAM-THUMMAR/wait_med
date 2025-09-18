import 'package:flutter/material.dart';
import 'personal_details_screen.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C5C64), // Burgundy color
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
                          color: const Color(0xFF9C5C64),
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
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Thummar Soham",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
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

                  // Account Settings Button - Exact design match
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
                        backgroundColor: const Color(0xFF9C5C64),
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

                  // Past/Recent Searches Button - Exact design match
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Optional: Show recent searches dialog or navigate to a detailed view
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C5C64),
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

                  // Recent Searches List - Exact design match
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
                  Navigator.of(context).pop(); // Go back to home
                } else if (index == 0) {}
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
                  icon: Icon(
                    Icons.person,
                    size: 28,
                  ), // Filled icon for selected state
                  label: '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF333333)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
          ),
        ),
      ],
    );
  }
}
