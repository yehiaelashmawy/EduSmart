import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class StudentExamReferenceMaterials extends StatelessWidget {
  const StudentExamReferenceMaterials({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reference Materials',
          style: AppTextStyle.bold16.copyWith(
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 16),
        _buildMaterialItem(
          icon: Icons.picture_as_pdf,
          iconColor: AppColors.secondaryColor,
          iconBackgroundColor: AppColors.primaryColor.withValues(alpha: 0.15),
          title: 'Physics_Summary.pdf',
          subtitle: '2.4 MB • Updated Oct 12',
          trailingIcon: Icons.download_rounded,
          onTap: () {},
        ),
        _buildMaterialItem(
          icon: Icons.link,
          iconColor: const Color(0xff4B48A1), // Purple from design
          iconBackgroundColor: const Color(0xff4B48A1).withValues(alpha: 0.15),
          title: 'Quantum Mechanics Basics',
          subtitle: 'External Video Link',
          trailingIcon: Icons.open_in_new_rounded,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildMaterialItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
    required String title,
    required String subtitle,
    required IconData trailingIcon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: AppTextStyle.bold14.copyWith(
            color: AppColors.darkBlue,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyle.medium12.copyWith(
            color: AppColors.grey,
            fontSize: 10,
          ),
        ),
        trailing: IconButton(
          icon: Icon(trailingIcon, color: AppColors.grey, size: 20),
          onPressed: onTap,
        ),
      ),
    );
  }
}
