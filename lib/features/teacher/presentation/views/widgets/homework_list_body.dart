import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/homework_details_view.dart';
import 'package:school_system/features/teacher/presentation/views/review_submissions_view.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/homework_list_item.dart';

class HomeworkListBody extends StatelessWidget {
  const HomeworkListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              style: AppTextStyle.regular14.copyWith(color: AppColors.darkBlue),
              decoration: InputDecoration(
                hintText: 'Search homework tasks...',
                hintStyle: AppTextStyle.regular14.copyWith(
                  color: AppColors.grey.withValues(alpha: 0.7),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.grey.withValues(alpha: 0.7),
                ),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: AppColors.lightGrey.withValues(alpha: 0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: AppColors.lightGrey.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                HomeworkItemCard(
                  title: 'Quadratic Equations',
                  subtitle: 'Grade 10-A • Mathematics',
                  statusText: 'ACTIVE',
                  badgeColor: const Color(0xFFD1FAE5),
                  badgeTextColor: const Color(0xFF065F46),
                  updatedTime: 'Updated 2h ago',
                  dueDate: 'Oct 25, 2023',
                  submissions: '24/32',
                  progress: 0.75,
                  buttonText: 'View Details >',
                  buttonColor: AppColors.primaryColor,
                  buttonTextColor: Colors.white,
                  isOverdue: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeworkDetailsView(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                HomeworkItemCard(
                  title: 'Modern Literature Essay',
                  subtitle: 'Grade 11-B • English',
                  statusText: 'ACTIVE',
                  badgeColor: const Color(0xFFDBEAFE),
                  badgeTextColor: const Color(0xFF1E40AF),
                  dueDate: 'Oct 28, 2023',
                  submissions: '12/28',
                  progress: 0.42,
                  buttonText: 'View Details',
                  buttonColor: const Color(0xFFEFF6FF),
                  buttonTextColor: AppColors.primaryColor,
                  isOverdue: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeworkDetailsView(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                HomeworkItemCard(
                  title: 'Chemical Reactions Lab',
                  subtitle: 'Grade 10-A • Science',
                  statusText: 'OVERDUE',
                  badgeColor: const Color(0xFFFEE2E2),
                  badgeTextColor: const Color(0xFF991B1B),
                  dueDate: 'Oct 20, 2023',
                  submissions: '30/32',
                  buttonText: 'Review Submissions',
                  buttonColor: const Color(0xFFF1F5F9),
                  buttonTextColor: const Color(0xFF475569),
                  isOverdue: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReviewSubmissionsView(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
