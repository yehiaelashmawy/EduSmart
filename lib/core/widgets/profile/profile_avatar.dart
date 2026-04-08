import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.name,
    required this.title,
    required this.onEditTap,
  });

  final String name;
  final String title;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            const CircleAvatar(
              radius: 65,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/images/profile_photo.png'),
            ),
            Positioned(
              bottom: 0,
              right: 4,
              child: GestureDetector(
                onTap: onEditTap,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 3),
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: AppTextStyle.bold16.copyWith(
            color: AppColors.darkBlue,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: AppTextStyle.regular14.copyWith(color: AppColors.grey),
        ),
      ],
    );
  }
}
