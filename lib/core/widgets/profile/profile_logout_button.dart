import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xffFEF2F2),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xffFECACA),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout,
              color: Color(0xffDC2626),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: AppTextStyle.semiBold14.copyWith(
                color: const Color(0xffDC2626),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
