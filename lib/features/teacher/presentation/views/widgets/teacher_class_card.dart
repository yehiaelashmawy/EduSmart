import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class TeacherClassCard extends StatelessWidget {
  final String image;
  final String badgeText;
  final String title;
  final String subtitle;
  final String numStudents;
  final String schedule;
  final int extraStudentsCount;
  final List<String> studentAvatars;
  final VoidCallback onViewClass;

  const TeacherClassCard({
    super.key,
    required this.image,
    required this.badgeText,
    required this.title,
    required this.subtitle,
    required this.numStudents,
    required this.schedule,
    required this.extraStudentsCount,
    this.studentAvatars = const [],
    required this.onViewClass,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: _buildCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ClassImageBanner(image: image, badgeText: badgeText),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ClassHeaderInfo(title: title, subtitle: subtitle),
                const SizedBox(height: 16),
                _ClassDetailsRow(numStudents: numStudents, schedule: schedule),
                const SizedBox(height: 24),
                _ClassActionRow(
                  extraStudentsCount: extraStudentsCount,
                  studentAvatars: studentAvatars,
                  onViewClass: onViewClass,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

class _ClassImageBanner extends StatelessWidget {
  const _ClassImageBanner({required this.image, required this.badgeText});

  final String image;
  final String badgeText;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SizedBox(
        height: 120,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(image, fit: BoxFit.cover),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff0F52BD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeText.toUpperCase(),
                  style: AppTextStyle.bold14.copyWith(
                    color: AppColors.white,
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClassHeaderInfo extends StatelessWidget {
  const _ClassHeaderInfo({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyle.bold18),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: AppTextStyle.regular14.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ),
        Icon(Icons.more_vert, color: AppColors.lightGrey),
      ],
    );
  }
}

class _ClassDetailsRow extends StatelessWidget {
  const _ClassDetailsRow({required this.numStudents, required this.schedule});

  final String numStudents;
  final String schedule;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.people_outline, size: 18, color: AppColors.grey),
        const SizedBox(width: 8),
        Text(
          '$numStudents Students',
          style: AppTextStyle.regular14.copyWith(
            color: AppColors.grey,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 16),
        Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.grey),
        const SizedBox(width: 8),
        Text(
          schedule,
          style: AppTextStyle.regular14.copyWith(
            color: AppColors.grey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _ClassActionRow extends StatelessWidget {
  const _ClassActionRow({
    required this.extraStudentsCount,
    required this.studentAvatars,
    required this.onViewClass,
  });

  final int extraStudentsCount;
  final List<String> studentAvatars;
  final VoidCallback onViewClass;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStudentAvatars(),
        ElevatedButton(
          onPressed: onViewClass,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff0F52BD),
            foregroundColor: AppColors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text('View Class', style: AppTextStyle.semiBold14),
        ),
      ],
    );
  }

  Widget _buildStudentAvatars() {
    final displayAvatars = studentAvatars.take(3).toList();
    return SizedBox(
      width: 110,
      height: 40,
      child: Stack(
        children: [
          ...displayAvatars.asMap().entries.map((entry) {
            return Positioned(
              left: entry.key * 20.0,
              child: _buildAvatar(entry.value),
            );
          }),
          if (extraStudentsCount > 0)
            Positioned(
              left: displayAvatars.length * 20.0,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.darkBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+$extraStudentsCount',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String imagePath) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: imagePath.isEmpty
            ? Icon(
                Icons.person,
                size: 20,
                color: AppColors.black.withValues(alpha: 0.54),
              )
            : imagePath.startsWith('assets')
            ? Image.asset(imagePath, fit: BoxFit.cover)
            : Image.network(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.person,
                  size: 20,
                  color: AppColors.black.withValues(alpha: 0.54),
                ),
              ),
      ),
    );
  }
}
