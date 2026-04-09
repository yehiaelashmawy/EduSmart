import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class TeacherCustomAppBar extends StatelessWidget {
  const TeacherCustomAppBar({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(color: AppColors.white),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFF8B9272),
            child: Icon(Icons.person, color: AppColors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: AppTextStyle.regular14.copyWith(color: AppColors.grey),
                ),
                const Text(
                  'Prof. Sarah Anderson',
                  style: AppTextStyle.bold16,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _buildIconButton(Icons.search),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {bool hasBadge = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: hasBadge
          ? Badge(
              smallSize: 8,
              backgroundColor: const Color(0xFFEF4444),
              child: Icon(icon, color: AppColors.darkBlue, size: 24),
            )
          : Icon(icon, color: AppColors.darkBlue, size: 24),
    );
  }
}
