import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/data/models/teacher_exam_model.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/exam_item_card.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/exams_toggle_bar.dart';
import 'package:school_system/core/helper/localization_helper.dart';

class ExamsListBody extends StatefulWidget {
  final List<TeacherExamModel> exams;
  final List<TeacherStudentModel> classStudents;
  final void Function(String examId)? onExamDeleted;

  const ExamsListBody({
    super.key,
    this.exams = const [],
    this.classStudents = const [],
    this.onExamDeleted,
  });

  @override
  State<ExamsListBody> createState() => _ExamsListBodyState();
}

class _ExamsListBodyState extends State<ExamsListBody> {
  bool _isUpcomingExams = true;

  List<TeacherExamModel> get _filteredExams {
    final now = DateTime.now();
    return widget.exams.where((exam) {
      final examDate = DateTime.tryParse(exam.date);
      if (examDate == null) return _isUpcomingExams;
      final isUpcoming = !examDate.isBefore(
        DateTime(now.year, now.month, now.day),
      );
      return _isUpcomingExams ? isUpcoming : !isUpcoming;
    }).toList();
  }

  String _formatDate(String rawDate) {
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null)
      return LocalizationHelper.isArabic
          ? 'تاريخ غير متاح'
          : 'Date unavailable';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[parsed.month - 1]} ${parsed.day}, ${parsed.year}';
  }

  String _formatTime(String rawDate, String startTime) {
    if (startTime.isNotEmpty) {
      final parts = startTime.split(':');
      if (parts.length >= 2) {
        final h = int.tryParse(parts[0]) ?? 0;
        final m = parts[1];
        final suffix = h >= 12 ? 'PM' : 'AM';
        final hour = h == 0 ? 12 : (h > 12 ? h - 12 : h);
        return '${hour.toString().padLeft(2, '0')}:$m $suffix';
      }
    }

    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return '--:--';
    final hour = parsed.hour == 0
        ? 12
        : parsed.hour > 12
        ? parsed.hour - 12
        : parsed.hour;
    final minute = parsed.minute.toString().padLeft(2, '0');
    final suffix = parsed.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:$minute $suffix';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Toggle Buttons
          ExamsToggleBar(
            isUpcomingExams: _isUpcomingExams,
            onToggle: (value) {
              setState(() {
                _isUpcomingExams = value;
              });
            },
          ),
          const SizedBox(height: 16),
          // Expanded List View
          Expanded(
            child: _filteredExams.isEmpty
                ? Center(
                    child: Text(
                      _isUpcomingExams
                          ? (LocalizationHelper.isArabic
                                ? 'لا توجد اختبارات قادمة.'
                                : 'No upcoming exams.')
                          : (LocalizationHelper.isArabic
                                ? 'لا توجد اختبارات سابقة.'
                                : 'No past exams.'),
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _filteredExams.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      if (index == _filteredExams.length) {
                        return const SizedBox(height: 80);
                      }
                      final exam = _filteredExams[index];
                      final isDraft =
                          exam.status.toLowerCase() == 'draft' ||
                          exam.status.toLowerCase() == 'pending';

                      return ExamItemCard(
                        exam: exam,
                        examId: exam.oid,
                        title: exam.name.isNotEmpty
                            ? exam.name
                            : (LocalizationHelper.isArabic
                                  ? 'اختبار بدون عنوان'
                                  : 'Untitled Exam'),
                        date: _formatDate(exam.date),
                        time: _formatTime(exam.date, exam.startTime),
                        subject: exam.subjectName.isNotEmpty
                            ? '${exam.subjectName} - ${exam.className}'
                            : (LocalizationHelper.isArabic
                                  ? 'اختبار دراسي'
                                  : 'Class Exam'),
                        grade: exam.maxScore > 0
                            ? (LocalizationHelper.isArabic
                                  ? 'أقصى درجة: ${exam.maxScore}'
                                  : 'Max Score: ${exam.maxScore}')
                            : (LocalizationHelper.isArabic
                                  ? 'درجة معلقة'
                                  : 'Pending score'),
                        status: exam.status.isNotEmpty
                            ? exam.status
                            : (_isUpcomingExams
                                  ? (LocalizationHelper.isArabic
                                        ? 'مؤكد'
                                        : 'CONFIRMED')
                                  : (LocalizationHelper.isArabic
                                        ? 'مكتمل'
                                        : 'COMPLETED')),
                        statusColor: _isUpcomingExams
                            ? AppColors.secondaryColor
                            : AppColors.grey,
                        isDraft: isDraft,
                        classStudents: widget.classStudents,
                        onDeleted: () {
                          widget.onExamDeleted?.call(exam.oid);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
