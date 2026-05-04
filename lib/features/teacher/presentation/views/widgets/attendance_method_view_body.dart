import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/presentation/manager/start_attendance_cubit/start_attendance_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/start_attendance_cubit/start_attendance_state.dart';
import 'package:school_system/features/teacher/presentation/views/generate_qr_code_view.dart';
import 'package:school_system/features/teacher/presentation/views/manual_attendance_view.dart';
import 'package:school_system/features/teacher/presentation/views/entry_code_view.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/attendance_method_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AttendanceMethodViewBody extends StatefulWidget {
  final TeacherClassModel teacherClass;
  final String? lessonId;

  const AttendanceMethodViewBody({
    super.key,
    required this.teacherClass,
    this.lessonId,
  });

  @override
  State<AttendanceMethodViewBody> createState() =>
      _AttendanceMethodViewBodyState();
}

class _AttendanceMethodViewBodyState extends State<AttendanceMethodViewBody> {
  String? _selectedLessonOid;

  @override
  void initState() {
    super.initState();
    _selectedLessonOid = widget.lessonId ?? _nextLesson?.oid;
  }

  List<TeacherLessonModel> get _classLessons {
    final students = widget.teacherClass.students;
    final map = <String, TeacherLessonModel>{};
    for (final student in students) {
      for (final lesson in student.details.lessons) {
        final key = lesson.oid.isNotEmpty
            ? lesson.oid
            : '${lesson.title}-${lesson.date}';
        map.putIfAbsent(key, () => lesson);
      }
    }
    final lessons = map.values.where((lesson) {
      final status = lesson.status.toLowerCase();
      return status != 'expired' && status != 'completed';
    }).toList();
    lessons.sort((a, b) {
      final da = DateTime.tryParse(a.date);
      final db = DateTime.tryParse(b.date);
      if (da == null || db == null) return 0;
      return da.compareTo(db); // ascending: nearest first
    });
    return lessons;
  }

  /// The nearest upcoming lesson (or most recent if all are past).
  TeacherLessonModel? get _nextLesson {
    final lessons = _classLessons;
    if (lessons.isEmpty) return null;
    final now = DateTime.now();
    // Find first lesson on/after today
    final upcoming = lessons.where((l) {
      final d = DateTime.tryParse(l.date);
      return d != null && !d.isBefore(DateTime(now.year, now.month, now.day));
    }).toList();
    if (upcoming.isNotEmpty) return upcoming.first;
    return lessons.last; // fall back to most recent past lesson
  }

  /// Returns OIDs of lessons that already have at least one student
  /// attendance record dated today.
  Set<String> get _takenLessonOids {
    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    final taken = <String>{};
    for (final lesson in _classLessons) {
      for (final student in widget.teacherClass.students) {
        final hasTodayRecord = student.details.attendance.recentRecords
            .any((r) => r.date.startsWith(todayStr));
        if (hasTodayRecord) {
          taken.add(lesson.oid);
          break;
        }
      }
    }
    return taken;
  }

  bool get _selectedIsTaken =>
      _selectedLessonOid != null &&
      _takenLessonOids.contains(_selectedLessonOid);

  String _formatDate(String raw) {
    final d = DateTime.tryParse(raw);
    if (d == null) return raw.split('T').first;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  String _formatTime(String raw) {
    final d = DateTime.tryParse(raw);
    if (d == null) return raw;
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final m = d.minute.toString().padLeft(2, '0');
    final suffix = d.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $suffix';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StartAttendanceCubit, StartAttendanceState>(
      listener: (context, state) {
        if (state is StartAttendanceSuccess) {
          if (state.session.method == 2) {
            Navigator.pushNamed(
              context,
              GenerateQrCodeView.routeName,
              arguments: state.session,
            ).then((value) {
              if (!mounted) return;
              if (value == true) Navigator.pop(context, true);
            });
          } else if (state.session.method == 3) {
            Navigator.pushNamed(
              context,
              EntryCodeView.routeName,
              arguments: state.session,
            ).then((value) {
              if (!mounted) return;
              if (value == true) Navigator.pop(context, true);
            });
          } else {
            Navigator.pushNamed(
              context,
              ManualAttendanceView.routeName,
              arguments: ManualAttendanceViewArgs(
                teacherClass: widget.teacherClass,
                session: state.session,
              ),
            ).then((value) {
              if (!mounted) return;
              if (value == true) Navigator.pop(context, true);
            });
          }
        } else if (state is StartAttendanceFailure) {
          CustomSnackBar.showError(context, state.failure.errorMessage);
        }
      },
      builder: (context, state) {
        final lesson = _nextLesson;
        final isLoading = state is StartAttendanceLoading;

        return Skeletonizer(
          enabled: isLoading,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            children: [
              // ── Header ─────────────────────────────────────────────
              Text(
                'UPCOMING LESSON',
                style: AppTextStyle.bold12.copyWith(
                  color: AppColors.grey,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),

              // ── Next Lesson Card ────────────────────────────────────
              if (lesson == null)
                _NoLessonCard()
              else
                _LessonInfoCard(
                  lesson: lesson,
                  isTaken: _takenLessonOids.contains(lesson.oid),
                  className:
                      '${widget.teacherClass.name} · ${widget.teacherClass.level}',
                  formatDate: _formatDate,
                  formatTime: _formatTime,
                ),

              const SizedBox(height: 32),

              if (lesson != null) ...[
                // ── Section heading ─────────────────────────────────
                Text(
                  _selectedIsTaken ? 'RE-TAKE SESSION' : 'SESSION MANAGEMENT',
                  style: AppTextStyle.bold12.copyWith(
                    color: AppColors.grey,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedIsTaken ? 'Re-take Attendance' : 'Take Attendance',
                  style: AppTextStyle.bold18.copyWith(color: AppColors.black),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: AppTextStyle.medium14.copyWith(
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Select a method to verify student presence for ',
                      ),
                      TextSpan(
                        text:
                            '${widget.teacherClass.name} - ${widget.teacherClass.level}',
                        style: AppTextStyle.medium14.copyWith(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Method cards ────────────────────────────────────
                AttendanceMethodCard(
                  icon: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xffDDE4FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.edit_calendar,
                      color: Color(0xff065AD8),
                    ),
                  ),
                  title: 'Manual Attendance',
                  subtitle:
                      'Personally mark students present or absent from the class roster.',
                  actionText: 'SELECT METHOD',
                  onTap: () {
                    if (_selectedLessonOid == null) {
                      CustomSnackBar.showError(
                        context,
                        'No lesson available',
                      );
                      return;
                    }
                    context.read<StartAttendanceCubit>().startSession(
                      classOid: widget.teacherClass.oid,
                      method: 1,
                      lessonOid: _selectedLessonOid,
                    );
                  },
                ),
                AttendanceMethodCard(
                  icon: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.qr_code, color: Colors.white),
                  ),
                  title: 'Generate QR Code',
                  subtitle:
                      'Display a dynamic code on the screen for students to scan with their devices.',
                  actionText: 'QUICK LAUNCH',
                  actionIcon: Icons.bolt,
                  isPrimary: true,
                  onTap: () {
                    if (_selectedLessonOid == null) {
                      CustomSnackBar.showError(context, 'No lesson available');
                      return;
                    }
                    context.read<StartAttendanceCubit>().startSession(
                      classOid: widget.teacherClass.oid,
                      method: 2,
                      lessonOid: _selectedLessonOid,
                    );
                  },
                ),
                AttendanceMethodCard(
                  icon: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.peach,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.pin, color: Color(0xff78350F)),
                  ),
                  title: 'Generate Code',
                  subtitle:
                      'Create a unique numeric key for students to enter manually.',
                  actionText: 'SELECT METHOD',
                  onTap: () {
                    if (_selectedLessonOid == null) {
                      CustomSnackBar.showError(context, 'No lesson available');
                      return;
                    }
                    context.read<StartAttendanceCubit>().startSession(
                      classOid: widget.teacherClass.oid,
                      method: 3,
                      lessonOid: _selectedLessonOid,
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ── Next Lesson Info Card ──────────────────────────────────────────────────

class _LessonInfoCard extends StatelessWidget {
  final TeacherLessonModel lesson;
  final bool isTaken;
  final String className;
  final String Function(String) formatDate;
  final String Function(String) formatTime;

  const _LessonInfoCard({
    required this.lesson,
    required this.isTaken,
    required this.className,
    required this.formatDate,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isTaken
              ? [const Color(0xff059669), const Color(0xff047857)]
              : [AppColors.secondaryColor, const Color(0xff1a3f8f)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isTaken
                    ? const Color(0xff059669)
                    : AppColors.secondaryColor)
                .withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: status chip + icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isTaken
                            ? Icons.check_circle_outline
                            : Icons.schedule_rounded,
                        color: Colors.white,
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isTaken ? 'ATTENDANCE TAKEN' : 'UPCOMING',
                        style: AppTextStyle.bold12.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isTaken ? Icons.how_to_reg_rounded : Icons.class_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Lesson title
            Text(
              lesson.title,
              style: AppTextStyle.bold18.copyWith(
                color: Colors.white,
                fontSize: 22,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              className,
              style: AppTextStyle.medium14.copyWith(
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 20),

            // Divider
            Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),

            // Date / time row
            Row(
              children: [
                _InfoChip(
                  icon: Icons.calendar_today_rounded,
                  label: formatDate(lesson.date),
                ),
                if (lesson.startTime.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  _InfoChip(
                    icon: Icons.access_time_rounded,
                    label:
                        '${formatTime(lesson.startTime)}${lesson.endTime.isNotEmpty ? ' – ${formatTime(lesson.endTime)}' : ''}',
                  ),
                ],
              ],
            ),

            // "Already taken" note
            if (isTaken) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.white70,
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Re-submitting will overwrite today\'s existing records.',
                        style: AppTextStyle.medium12.copyWith(
                          color: Colors.white70,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 14),
        const SizedBox(width: 5),
        Text(
          label,
          style: AppTextStyle.medium12.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}

class _NoLessonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 48,
            color: AppColors.lightGrey,
          ),
          const SizedBox(height: 12),
          Text(
            'No Lessons Available',
            style: AppTextStyle.bold16.copyWith(color: AppColors.darkBlue),
          ),
          const SizedBox(height: 6),
          Text(
            'There are no active lessons for this class. Please add a lesson first.',
            style: AppTextStyle.medium14.copyWith(
              color: AppColors.grey,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
