import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/helper/localization_helper.dart';

class StudentBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const StudentBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.home_outlined),
        ),
        activeIcon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.home),
        ),
        label: 'nav_home'.tr(),
      ),
      BottomNavigationBarItem(
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.book_outlined),
        ),
        activeIcon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.book),
        ),
        label: 'nav_subjects'.tr(),
      ),
      BottomNavigationBarItem(
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.chat_bubble_outline),
        ),
        activeIcon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.chat_bubble),
        ),
        label: 'nav_messages'.tr(),
      ),
      BottomNavigationBarItem(
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.notifications_none),
        ),
        activeIcon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.notifications),
        ),
        label: 'nav_alerts'.tr(),
      ),
      BottomNavigationBarItem(
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.person_outline),
        ),
        activeIcon: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Icon(Icons.person),
        ),
        label: 'nav_profile'.tr(),
      ),
    ];

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
        items: items,
      ),
    );
  }
}
