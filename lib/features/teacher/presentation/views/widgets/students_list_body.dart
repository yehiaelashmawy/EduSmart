import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/student_list_item.dart';

class StudentsListBody extends StatelessWidget {
  const StudentsListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ENROLLED STUDENTS (24)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list, size: 18, color: AppColors.primaryColor),
                  label: const Text(
                    'Filter',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: 6,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: Color(0xffE2E8F0),
              ),
              itemBuilder: (context, index) {
                return StudentListItem(
                  name: ['Aiden Thompson', 'Sophia Garcia', 'Marcus Chen', 'Emily Watson', 'Leo Rodriguez', 'Isabella Kim'][index],
                  id: ['#EDU10234', '#EDU10289', '#EDU10301', '#EDU10255', '#EDU10412', '#EDU10377'][index],
                  isOnline: index == 0,
                  avatarColor: const [Color(0xFFFDE68A), Color(0xFFFECACA), Color(0xFFFDE68A), Color(0xFFFECACA), Color(0xFFFDE68A), Color(0xFFFDE68A)][index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
