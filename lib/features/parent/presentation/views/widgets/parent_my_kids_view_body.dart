import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/data/models/parent_dashboard_model.dart';
import 'package:school_system/features/parent/presentation/views/widgets/child_details_header.dart';
import 'package:school_system/features/parent/presentation/views/widgets/quick_actions_tabs.dart';
import 'package:school_system/features/parent/presentation/views/widgets/recent_activity_list.dart';
import 'package:school_system/features/parent/presentation/views/widgets/subject_performance_list.dart';
import 'package:school_system/features/parent/presentation/views/widgets/upcoming_events_list.dart';
import 'package:school_system/features/parent/presentation/views/widgets/view_schedule_button.dart';

class ParentMyKidsViewBody extends StatefulWidget {
  final ParentChildModel? child;
  const ParentMyKidsViewBody({super.key, this.child});

  @override
  State<ParentMyKidsViewBody> createState() => _ParentMyKidsViewBodyState();
}

class _ParentMyKidsViewBodyState extends State<ParentMyKidsViewBody> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChildDetailsHeader(child: widget.child),
          const SizedBox(height: 16),
          QuickActionsTabs(
            currentIndex: _selectedTabIndex,
            onTabChanged: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
          ),
          const SizedBox(height: 24),
          // Content changes based on selection
          _buildTabContent(),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    if (_selectedTabIndex == 1) {
      return _buildAttendanceTab();
    }
    if (_selectedTabIndex == 2) {
      return _buildGradesTab();
    }
    if (_selectedTabIndex == 3) {
      return _buildHomeworkTab();
    }
    
    if (_selectedTabIndex != 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_awesome_mosaic_rounded,
                    size: 48, color: AppColors.grey.withValues(alpha: 0.4)),
              ),
              const SizedBox(height: 24),
              Text(
                'Coming Soon',
                style: AppTextStyle.bold18.copyWith(color: AppColors.darkBlue),
              ),
              const SizedBox(height: 8),
              Text(
                'We\'re working on bringing more\ndetails for this section.',
                textAlign: TextAlign.center,
                style: AppTextStyle.medium14.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: ViewScheduleButton(),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(Icons.bar_chart_rounded, 'Performance Overview'),
              const SizedBox(height: 16),
              const SubjectPerformanceList(),
              const SizedBox(height: 32),
              _buildSectionHeader(Icons.history_rounded, 'Recent Activities'),
              const SizedBox(height: 16),
              const RecentActivityList(),
              const SizedBox(height: 32),
              _buildSectionHeader(Icons.event_note_rounded, 'Upcoming Schedule'),
              const SizedBox(height: 16),
              const UpcomingEventsList(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(Icons.calendar_view_day, 'This Week Attendance'),
          const SizedBox(height: 16),
          _buildThisWeekAttendanceList(),
          const SizedBox(height: 32),
          _buildSectionHeader(Icons.bar_chart, 'Subject Attendance'),
          const SizedBox(height: 16),
          _buildSubjectAttendanceList(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildGradesTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildSubjectGradeCard(
            subject: 'Mathematics',
            percent: '94%',
            letterGrade: 'A',
            quizzes: [
              {'title': 'Mid-term Exam', 'date': 'Oct 15, 2023', 'percent': 92},
              {'title': 'Chapter 4 Quiz', 'date': 'Oct 02, 2023', 'percent': 96},
            ],
            assignments: [
              {'title': 'Problem Set 5', 'date': 'Oct 20, 2023', 'percent': 95},
              {'title': 'Problem Set 4', 'date': 'Oct 10, 2023', 'percent': 100},
            ],
          ),
          const SizedBox(height: 24),
          _buildSubjectGradeCard(
            subject: 'Physics',
            percent: '88%',
            letterGrade: 'B+',
            quizzes: [
              {'title': 'Mid-term Exam', 'date': 'Oct 18, 2023', 'percent': 85},
              {'title': 'Kinematics Quiz', 'date': 'Sep 25, 2023', 'percent': 90},
            ],
            assignments: [
              {'title': 'Lab Report: Free Fall', 'date': 'Oct 22, 2023', 'percent': 92},
              {'title': 'Homework 3', 'date': 'Oct 12, 2023', 'percent': 88},
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHomeworkTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(Icons.assignment_outlined, 'Homework Assignments'),
          const SizedBox(height: 24),
          _buildHomeworkCard(
            title: 'Algebra Worksheet 4.2',
            subject: 'Mathematics',
            info: 'Due: Tomorrow, 11:59 PM',
            status: 'PENDING',
          ),
          _buildHomeworkCard(
            title: 'Physics Lab Report',
            subject: 'Science',
            info: 'Submitted: Oct 23, 2024',
            status: 'SUBMITTED',
          ),
          _buildHomeworkCard(
            title: 'English Essay: The Great Gatsby',
            subject: 'Literature',
            info: 'Submitted: Oct 18, 2024',
            status: 'GRADED',
            grade: '95/100',
            comment: 'Excellent analysis!',
          ),
          _buildHomeworkCard(
            title: 'World History Chapter 5 Quiz',
            subject: 'History',
            info: 'Submitted: Oct 15, 2024',
            status: 'GRADED',
            grade: '98/100',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHomeworkCard({
    required String title,
    required String subject,
    required String info,
    required String status,
    String? grade,
    String? comment,
  }) {
    Color statusColor;
    Color statusBgColor;

    switch (status) {
      case 'PENDING':
        statusColor = Colors.orange;
        statusBgColor = Colors.orange.withValues(alpha: 0.1);
        break;
      case 'SUBMITTED':
        statusColor = AppColors.primaryColor;
        statusBgColor = AppColors.primaryColor.withValues(alpha: 0.1);
        break;
      case 'GRADED':
        statusColor = const Color(0xFF4CAF50);
        statusBgColor = const Color(0xFF4CAF50).withValues(alpha: 0.1);
        break;
      default:
        statusColor = AppColors.grey;
        statusBgColor = AppColors.grey.withValues(alpha: 0.1);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.bold16.copyWith(color: AppColors.darkBlue),
          ),
          const SizedBox(height: 8),
          Text(
            '$subject \u2022 $info',
            style: AppTextStyle.medium14.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: AppTextStyle.bold12.copyWith(color: statusColor, fontSize: 10),
                ),
              ),
              if (grade != null) ...[
                const SizedBox(width: 12),
                Text(
                  grade,
                  style: AppTextStyle.bold14.copyWith(color: AppColors.primaryColor),
                ),
              ],
            ],
          ),
          if (comment != null) ...[
            const SizedBox(height: 12),
            Text(
              comment,
              style: AppTextStyle.medium14.copyWith(
                color: AppColors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubjectGradeCard({
    required String subject,
    required String percent,
    required String letterGrade,
    required List<Map<String, dynamic>> quizzes,
    required List<Map<String, dynamic>> assignments,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.03),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Text(
                  subject,
                  style: AppTextStyle.bold18.copyWith(color: AppColors.darkBlue),
                ),
                const Spacer(),
                Text(
                  percent,
                  style: AppTextStyle.bold18.copyWith(color: AppColors.primaryColor),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    letterGrade,
                    style: AppTextStyle.bold12.copyWith(color: AppColors.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGradeSectionHeader(Icons.quiz_outlined, 'QUIZZES & EXAMS'),
                const SizedBox(height: 16),
                ...quizzes.map((q) => _buildGradeItem(q['title'], q['date'], q['percent'])),
                const SizedBox(height: 24),
                _buildGradeSectionHeader(Icons.assignment_outlined, 'ASSIGNMENTS'),
                const SizedBox(height: 16),
                ...assignments.map((a) => _buildGradeItem(a['title'], a['date'], a['percent'])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.grey),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyle.bold12.copyWith(
            color: AppColors.grey,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildGradeItem(String title, String date, int percent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyle.medium14.copyWith(color: AppColors.darkBlue),
              ),
              Text(
                '$percent%',
                style: AppTextStyle.bold14.copyWith(color: AppColors.primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: AppColors.grey.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThisWeekAttendanceList() {
    final attendance = [
      {'day': 'Sunday', 'date': 'Oct 20, 2024', 'status': 'PRESENT'},
      {'day': 'Monday', 'date': 'Oct 21, 2024', 'status': 'PRESENT'},
      {'day': 'Tuesday', 'date': 'Oct 22, 2024', 'status': 'LATE'},
      {'day': 'Wednesday', 'date': 'Oct 23, 2024', 'status': 'ABSENT'},
      {'day': 'Thursday (Today)', 'date': 'Oct 24, 2024', 'status': 'PRESENT'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: attendance.asMap().entries.map((entry) {
          final item = entry.value;
          final isLast = entry.key == attendance.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['day']!,
                          style: AppTextStyle.bold14.copyWith(
                            color: item['day']!.contains('Today') 
                                ? AppColors.primaryColor 
                                : AppColors.darkBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['date']!,
                          style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
                        ),
                      ],
                    ),
                    const Spacer(),
                    _buildStatusChip(item['status']!),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  color: AppColors.grey.withValues(alpha: 0.1),
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'PRESENT':
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF4CAF50);
        break;
      case 'LATE':
        bgColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFFF9800);
        break;
      case 'ABSENT':
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFF44336);
        break;
      default:
        bgColor = AppColors.lightGrey;
        textColor = AppColors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppTextStyle.bold12.copyWith(color: textColor, fontSize: 10),
      ),
    );
  }

  Widget _buildSubjectAttendanceList() {
    final subjects = [
      {'name': 'Mathematics', 'sessions': '19/20 sessions', 'percent': 95, 'color': AppColors.primaryColor},
      {'name': 'Computer Science', 'sessions': '17/20 sessions', 'percent': 85, 'color': AppColors.primaryColor},
      {'name': 'World History', 'sessions': '20/20 sessions', 'percent': 100, 'color': AppColors.primaryColor},
      {'name': 'Modern Chemistry', 'sessions': '18/20 sessions', 'percent': 90, 'color': AppColors.primaryColor},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: subjects.map((subject) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject['name'] as String,
                          style: AppTextStyle.bold14.copyWith(color: AppColors.darkBlue),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subject['sessions'] as String,
                          style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
                        ),
                      ],
                    ),
                    Text(
                      '${subject['percent']}%',
                      style: AppTextStyle.bold14.copyWith(color: AppColors.primaryColor),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (subject['percent'] as int) / 100,
                    backgroundColor: AppColors.grey.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(subject['color'] as Color),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: AppTextStyle.bold14.copyWith(
            color: AppColors.darkBlue,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
