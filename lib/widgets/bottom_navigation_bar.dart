import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppTheme.primaryColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex, // ✅ use the passed-in value
      onTap: onTap,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on_outlined, size: 28),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 28),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, size: 28),
          label: '',
        ),
      ],
    );
  }
}
