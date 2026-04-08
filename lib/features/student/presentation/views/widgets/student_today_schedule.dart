import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';

class StudentTodaySchedule extends StatelessWidget {
  const StudentTodaySchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                    height: 1.1,
                  ),
                ),
                Text(
                  "Schedule",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                    height: 1.1,
                  ),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed('weekly_schedule_view');
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primaryColor.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'VIEW WEEK\nSCHEDULE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightGrey.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
          ),
          child: const Column(
            children: [
              _ScheduleItem(
                time: '09:00',
                period: 'NOW',
                subject: 'Physics',
                topic: 'Quantum Mechanics Basics',
                room: 'R. 402',
                isActive: true,
                hasDivider: true,
              ),
              _ScheduleItem(
                time: '12:30',
                period: 'PM',
                subject: 'Literature',
                topic: 'Prof. Elena',
                room: 'R. 104',
                isActive: false,
                hasDivider: true,
              ),
              _ScheduleItem(
                time: '02:15',
                period: 'PM',
                subject: 'Chemistry',
                topic: 'Organic Compounds',
                room: 'LAB B',
                isActive: false,
                hasDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String time;
  final String period;
  final String subject;
  final String topic;
  final String room;
  final bool isActive;
  final bool hasDivider;

  const _ScheduleItem({
    required this.time,
    required this.period,
    required this.subject,
    required this.topic,
    required this.room,
    required this.isActive,
    required this.hasDivider,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isActive ? AppColors.primaryColor : AppColors.grey,
                  ),
                ),
                Text(
                  period,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? AppColors.primaryColor : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            color: isActive ? AppColors.primaryColor : Colors.transparent,
            thickness: 2,
            width: 2,
            indent: 10,
            endIndent: 10,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subject,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              topic,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primaryColor : AppColors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          room,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isActive ? Colors.white : AppColors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      isActive
                          ? Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.person, color: Colors.white, size: 16),
                            )
                          : const Icon(Icons.more_vert, color: Colors.grey, size: 24),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (hasDivider)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.lightGrey.withValues(alpha: 0.3),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
