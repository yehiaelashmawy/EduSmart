import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/theme_manager.dart';

enum AttendanceStatus { present, absent, none }

class StudentAttendanceCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String imagePath;
  final bool hasHonorRoll;
  final AttendanceStatus status;
  final ValueChanged<AttendanceStatus> onStatusChanged;

  const StudentAttendanceCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.imagePath,
    required this.status,
    required this.onStatusChanged,
    this.hasHonorRoll = false,
  });

  void _handleStatusTap(AttendanceStatus newStatus) {
    if (status == newStatus) {
      onStatusChanged(AttendanceStatus.none);
    } else {
      onStatusChanged(newStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemeManager.isDarkMode
              ? AppColors.lightGrey.withOpacity(0.2)
              : AppColors.lightGrey.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 320;

          final studentInfo = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: AppTextStyle.bold16.copyWith(color: AppColors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyle.medium12.copyWith(color: AppColors.grey),
                    ),
                    if (hasHonorRoll) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffDDE4FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'HONOR ROLL',
                          style: AppTextStyle.bold12.copyWith(
                            color: const Color(0xff065AD8),
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                studentInfo,
                const SizedBox(height: 16),
                _buildToggle(expanded: true),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: studentInfo),
              const SizedBox(width: 12),
              _buildToggle(expanded: false),
            ],
          );
        },
      ),
    );
  }

  Widget _buildToggle({required bool expanded}) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ThemeManager.isDarkMode
            ? AppColors.lightGrey.withOpacity(0.3)
            : const Color(0xffEBEef4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        children: [
          _wrapOption(
            expanded: expanded,
            child: _ToggleOption(
              text: 'Present',
              isSelected: status == AttendanceStatus.present,
              selectedColor: const Color(0xff065AD8),
              onTap: () => _handleStatusTap(AttendanceStatus.present),
            ),
          ),
          _wrapOption(
            expanded: expanded,
            child: _ToggleOption(
              text: 'Absent',
              isSelected: status == AttendanceStatus.absent,
              selectedColor: const Color(0xffBD2828),
              onTap: () => _handleStatusTap(AttendanceStatus.absent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wrapOption({required bool expanded, required Widget child}) {
    return expanded ? Expanded(child: child) : child;
  }
}

class _ToggleOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.text,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: isSelected
              ? AppTextStyle.semiBold12.copyWith(color: Colors.white)
              : AppTextStyle.medium12.copyWith(color: AppColors.grey),
        ),
      ),
    );
  }
}
