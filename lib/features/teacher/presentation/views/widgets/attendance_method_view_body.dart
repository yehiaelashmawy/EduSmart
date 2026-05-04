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
import 'package:school_system/features/teacher/presentation/manager/teacher_classes_cubit/teacher_classes_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_classes_cubit/teacher_classes_state.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/attendance_method_card.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/lesson_info_card.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/no_lesson_card.dart';
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


  TeacherLessonModel? get _nextLesson {
    final lessons = _getLessonsFromClass(widget.teacherClass);
    return _getNextLessonFromLessons(lessons);
  }


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
              if (value == true && context.mounted) {
                Navigator.pop(context, true);
              }
            });
          } else if (state.session.method == 3) {
            Navigator.pushNamed(
              context,
              EntryCodeView.routeName,
              arguments: state.session,
            ).then((value) {
              if (value == true && context.mounted) {
                Navigator.pop(context, true);
              }
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
              if (value == true && context.mounted) {
                Navigator.pop(context, true);
              }
            });
          }
        } else if (state is StartAttendanceFailure) {
          if (context.mounted) {
            CustomSnackBar.showError(context, state.failure.errorMessage);
          }
        }
      },
      builder: (context, state) {
        return BlocBuilder<TeacherClassesCubit, TeacherClassesState>(
          builder: (context, classState) {
            // Use the most recent class data if available in the cubit
            TeacherClassModel currentClass = widget.teacherClass;
            if (classState is TeacherClassesSuccess) {
              currentClass = classState.classes.firstWhere(
                (c) => c.oid == widget.teacherClass.oid,
                orElse: () => widget.teacherClass,
              );
            }

            final lessons = _getLessonsFromClass(currentClass);
            final nextLesson = _getNextLessonFromLessons(lessons);
            final takenOids = _getTakenLessonOids(currentClass, lessons);
            final selectedIsTaken =
                _selectedLessonOid != null && takenOids.contains(_selectedLessonOid);
            
            // Auto-select next lesson if nothing selected
            if (_selectedLessonOid == null && nextLesson != null) {
              _selectedLessonOid = nextLesson.oid;
            }

            final isLoading = state is StartAttendanceLoading;

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<TeacherClassesCubit>().fetchClasses();
              },
              color: AppColors.secondaryColor,
              child: Skeletonizer(
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
                    if (nextLesson == null)
                      const NoLessonCard()
                    else
                      LessonInfoCard(
                        lesson: nextLesson,
                        isTaken: takenOids.contains(nextLesson.oid),
                        className:
                            '${currentClass.name} · ${currentClass.level}',
                        formatDate: _formatDate,
                        formatTime: _formatTime,
                      ),

                    const SizedBox(height: 32),

                    if (nextLesson != null) ...[
                      // ── Section heading ─────────────────────────────────
                      Text(
                        selectedIsTaken ? 'RE-TAKE SESSION' : 'SESSION MANAGEMENT',
                        style: AppTextStyle.bold12.copyWith(
                          color: AppColors.grey,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedIsTaken ? 'Re-take Attendance' : 'Take Attendance',
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
                                  '${currentClass.name} - ${currentClass.level}',
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
                            classOid: currentClass.oid,
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
                            classOid: currentClass.oid,
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
                            classOid: currentClass.oid,
                            method: 3,
                            lessonOid: _selectedLessonOid,
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<TeacherLessonModel> _getLessonsFromClass(TeacherClassModel teacherClass) {
    final students = teacherClass.students;
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

  TeacherLessonModel? _getNextLessonFromLessons(List<TeacherLessonModel> lessons) {
    if (lessons.isEmpty) return null;
    final now = DateTime.now();
    final upcoming = lessons.where((l) {
      final d = DateTime.tryParse(l.date);
      return d != null && !d.isBefore(DateTime(now.year, now.month, now.day));
    }).toList();
    if (upcoming.isNotEmpty) return upcoming.first;
    return lessons.last;
  }

  Set<String> _getTakenLessonOids(
      TeacherClassModel teacherClass, List<TeacherLessonModel> lessons) {
    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    final taken = <String>{};
    for (final lesson in lessons) {
      for (final student in teacherClass.students) {
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
}
