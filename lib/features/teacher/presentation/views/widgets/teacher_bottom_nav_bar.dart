import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';

class TeacherBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const TeacherBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Icon(Icons.home_outlined),
      ),
      activeIcon: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Icon(Icons.home),
      ),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Icon(Icons.school_outlined),
      ),
      activeIcon: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Icon(Icons.school),
      ),
      label: 'Classes',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Icon(Icons.chat_bubble_outline),
      ),
      activeIcon: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Icon(Icons.chat_bubble),
      ),
      label: 'Messages',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Icon(Icons.notifications_none),
      ),
      activeIcon: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Icon(Icons.notifications),
      ),
      label: 'Alerts',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Icon(Icons.person_outline),
      ),
      activeIcon: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Icon(Icons.person),
      ),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.grey.withValues(alpha: 0.6),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
        items: _items,
      ),
    );
  }
}
