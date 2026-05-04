import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/presentation/views/homework_details_view.dart';
import 'package:school_system/features/teacher/presentation/views/review_submissions_view.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/features/teacher/data/repos/submissions_repo.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/homework_list_item.dart';

class HomeworkListBody extends StatefulWidget {
  final List<TeacherHomeworkModel> homeworks;
  final List<TeacherStudentModel> classStudents;

  const HomeworkListBody({
    super.key,
    this.homeworks = const [],
    this.classStudents = const [],
  });

  @override
  State<HomeworkListBody> createState() => _HomeworkListBodyState();
}

class _HomeworkListBodyState extends State<HomeworkListBody> {
  late List<TeacherHomeworkModel> _homeworks;
  final Map<String, int> _realSubmissionCounts = {};

  @override
  void initState() {
    super.initState();
    _homeworks = List.from(widget.homeworks);
    _fetchRealSubmissionCounts();
  }

  @override
  void didUpdateWidget(HomeworkListBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.homeworks != widget.homeworks) {
      _homeworks = List.from(widget.homeworks);
      _fetchRealSubmissionCounts();
    }
  }

  Future<void> _fetchRealSubmissionCounts() async {
    final repo = SubmissionsRepo(ApiService());
    for (final hw in _homeworks) {
      if (!_realSubmissionCounts.containsKey(hw.oid)) {
        final res = await repo.getSubmissions(hw.oid);
        res.fold((l) => null, (list) {
          if (mounted) {
            setState(() {
              _realSubmissionCounts[hw.oid] = list.length;
            });
          }
        });
      }
    }
  }

  String _formatDate(String rawDate) {
    if (rawDate.trim().isEmpty) return 'Date unavailable';
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;
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

  _HomeworkUiState _mapStatus(String status, String dueDate) {
    final normalized = status.trim().toLowerCase();
    final parsedDue = DateTime.tryParse(dueDate);
    final isPastDue = parsedDue != null && parsedDue.isBefore(DateTime.now());

    if (normalized == 'grading') {
      return _HomeworkUiState(
        label: 'GRADING',
        badgeColor: const Color(0xFFDBEAFE),
        badgeTextColor: const Color(0xFF1E40AF),
        isOverdue: false,
      );
    }
    if (normalized == 'completed') {
      return _HomeworkUiState(
        label: 'COMPLETED',
        badgeColor: const Color(0xFFE2E8F0),
        badgeTextColor: const Color(0xFF334155),
        isOverdue: false,
      );
    }
    if (isPastDue) {
      return _HomeworkUiState(
        label: 'OVERDUE',
        badgeColor: const Color(0xFFFEE2E2),
        badgeTextColor: const Color(0xFF991B1B),
        isOverdue: true,
      );
    }
    return _HomeworkUiState(
      label: 'ACTIVE',
      badgeColor: const Color(0xFFD1FAE5),
      badgeTextColor: const Color(0xFF065F46),
      isOverdue: false,
    );
  }

  Future<void> _openDetails(
    BuildContext context,
    TeacherHomeworkModel homework,
  ) async {
    final deleted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => HomeworkDetailsView(homeworkId: homework.oid),
      ),
    );

    if (deleted == true) {
      setState(() {
        _homeworks.removeWhere((h) => h.oid == homework.oid);
      });
    }
  }

  void _openReview(BuildContext context, TeacherHomeworkModel homework) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewSubmissionsView(
          homeworkId: homework.oid,
          homeworkTitle: homework.title.isNotEmpty
              ? homework.title
              : 'Submissions',
          classStudents: widget.classStudents,
        ),
      ),
    );
  }

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
            child: _homeworks.isEmpty
                ? Center(
                    child: Text(
                      'No homework found for this class.',
                      style: AppTextStyle.semiBold16.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _homeworks.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final homework = _homeworks[index];
                      final ui = _mapStatus(homework.status, homework.dueDate);
                      final realCount = _realSubmissionCounts[homework.oid] ?? homework.submittedCount ?? 0;
                      return HomeworkItemCard(
                        title: homework.title.isNotEmpty
                            ? homework.title
                            : 'Untitled Homework',
                        subtitle: 'Class ${homework.status}',
                        statusText: ui.label,
                        badgeColor: ui.badgeColor,
                        badgeTextColor: ui.badgeTextColor,
                        dueDate: _formatDate(homework.dueDate),
                        submissions: '$realCount/${homework.totalStudents ?? (widget.classStudents.isNotEmpty ? widget.classStudents.length : 0)}',
                        progress: (homework.totalStudents ?? (widget.classStudents.isNotEmpty ? widget.classStudents.length : 0)) > 0
                            ? realCount / (homework.totalStudents ?? (widget.classStudents.isNotEmpty ? widget.classStudents.length : 1))
                            : 0.0,
                        isOverdue: ui.isOverdue,
                        onDetailsTap: () => _openDetails(context, homework),
                        onReviewTap: () => _openReview(context, homework),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _HomeworkUiState {
  final String label;
  final Color badgeColor;
  final Color badgeTextColor;
  final bool isOverdue;

  const _HomeworkUiState({
    required this.label,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.isOverdue,
  });
}
