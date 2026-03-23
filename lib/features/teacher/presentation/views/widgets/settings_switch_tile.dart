import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.transparent,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xffF1F5F9), // Light greyish blue
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.secondaryColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.semiBold14.copyWith(
                color: AppColors.darkBlue,
                fontSize: 16,
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeColor: AppColors.secondaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
