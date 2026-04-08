import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/student/data/models/weekly_schedule_models.dart';

class DailyCurriculumSection extends StatelessWidget {
  final String dateString;
  final List<CurriculumItem> items;

  const DailyCurriculumSection({
    super.key,
    required this.dateString,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Curriculum",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                dateString,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ...items.map((item) {
          if (item.type == 'LUNCH_BREAK') {
            return const _LunchBreakDivider();
          }
          return _CurriculumCard(item: item);
        }),
      ],
    );
  }
}

class _LunchBreakDivider extends StatelessWidget {
  const _LunchBreakDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: AppColors.lightGrey.withValues(alpha: 0.5)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'LUNCH BREAK',
              style: TextStyle(
                color: AppColors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            child: Divider(color: AppColors.lightGrey.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }
}

class _CurriculumCard extends StatelessWidget {
  final CurriculumItem item;

  const _CurriculumCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    item.startTime,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: item.isActive
                          ? AppColors.secondaryColor
                          : AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.endTime,
                    style: TextStyle(fontSize: 10, color: AppColors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBlue,
                              height: 1.2,
                            ),
                          ),
                        ),
                        Icon(
                          _getIconForTitle(item.title),
                          color: AppColors.primaryColor.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.subtitle,
                      style: TextStyle(fontSize: 12, color: AppColors.grey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: item.type == 'REQUIRED'
                                ? AppColors.primaryColor.withValues(alpha: 0.2)
                                : AppColors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.type,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: item.type == 'REQUIRED'
                                  ? AppColors.secondaryColor
                                  : AppColors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (item.avatars.isNotEmpty) ...[
                          Expanded(child: const SizedBox()),
                          _buildAvatars(item.avatars),
                        ] else if (item.alertText != null) ...[
                          Expanded(child: const SizedBox()),
                          const Icon(
                            Icons.error,
                            color: Color(0xFFC05621),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.alertText!,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC05621),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    if (title.contains('Physics')) return Icons.science_outlined;
    if (title.contains('Math')) return Icons.calculate_outlined;
    if (title.contains('Computer')) return Icons.memory_outlined;
    return Icons.book_outlined;
  }

  Widget _buildAvatars(List<String> avatars) {
    return SizedBox(
      height: 24,
      width: 60,
      child: Stack(
        children: List.generate(
          avatars.length,
          (index) => Positioned(
            right: index * 14.0,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white,
              child: index == 2
                  ? CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.lightGrey,
                      child: Text(
                        avatars[index],
                        style: TextStyle(
                          fontSize: 8,
                          color: AppColors.darkBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : CircleAvatar(
                      radius: 10,
                      backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/thumb/men/${40 + index}.jpg',
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
