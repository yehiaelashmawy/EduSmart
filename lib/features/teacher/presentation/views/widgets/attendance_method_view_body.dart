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

import 'package:school_system/features/teacher/presentation/views/widgets/lesson_info_card.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/no_lesson_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/services.dart';

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
  int? _selectedMethod;
  int? _correctNumber;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedLessonOid = widget.lessonId ?? _nextLesson?.oid;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedLessonOid != null) {
        final lessons = _getLessonsFromClass(widget.teacherClass);
        final index = lessons.indexWhere((l) => l.oid == _selectedLessonOid);
        if (index != -1) _scrollToSelectedLesson(index);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedLesson(int index) {
    if (_scrollController.hasClients) {
      final width = MediaQuery.of(context).size.width * 0.75 + 16;
      _scrollController.animateTo(
        index * width,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String get _buttonLabel {
    if (_selectedMethod == null) return "Select a Method";
    if (_selectedMethod == 1) return "Start Manual Session";
    if (_selectedMethod == 2) return "Generate QR Code";
    if (_selectedMethod == 3 && (_correctNumber == null || _correctNumber! <= 0)) {
      return "Enter a Code Number";
    }
    return "Generate Code Session";
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
                      'UPCOMING LESSONS',
                      style: AppTextStyle.bold12.copyWith(
                        color: AppColors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Upcoming Lessons Horizontal List ─────────────────────────
                    if (lessons.isEmpty)
                      const NoLessonCard()
                    else
                      SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: lessons.asMap().entries.map((entry) {
                              final index = entry.key;
                              final lesson = entry.value;
                              final isTaken = takenOids.contains(lesson.oid);
                              final isSelected = _selectedLessonOid == lesson.oid;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedLessonOid = lesson.oid;
                                  });
                                  _scrollToSelectedLesson(index);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.75,
                                  margin: EdgeInsets.only(
                                    right: lesson == lessons.last ? 0 : 16,
                                  ),
                                  child: LessonInfoCard(
                                    lesson: lesson,
                                    isTaken: isTaken,
                                    isSelected: isSelected,
                                    className:
                                        '${currentClass.name} · ${currentClass.level}',
                                    formatDate: _formatDate,
                                    formatTime: _formatTime,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                    const SizedBox(height: 32),

                    if (lessons.isNotEmpty) ...[
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
                      if (selectedIsTaken) ...[
                        Text(
                          "Re-submitting will overwrite today's existing records.",
                          style: AppTextStyle.medium12.copyWith(color: Colors.red),
                        ),
                        const SizedBox(height: 6),
                      ],
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
                      _buildMethodRow(
                        methodValue: 1,
                        icon: Icons.assignment_rounded,
                        title: 'Manual',
                        subtitle: 'Mark each student directly',
                      ),
                      _buildMethodRow(
                        methodValue: 2,
                        icon: Icons.qr_code_2,
                        title: 'QR Code',
                        subtitle: 'Students scan with their phones',
                      ),
                      _buildMethodRow(
                        methodValue: 3,
                        icon: Icons.numbers,
                        title: 'Random Code',
                        subtitle: 'Students enter the correct number',
                      ),

                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: _selectedMethod == 3
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8, bottom: 16),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  style: AppTextStyle.bold16.copyWith(
                                    color: AppColors.black,
                                    fontSize: 18,
                                    letterSpacing: 2.0,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'e.g. 80',
                                    hintStyle: AppTextStyle.medium14.copyWith(
                                      color: AppColors.grey.withValues(alpha: 0.6),
                                      letterSpacing: 0,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xffF4F7FB),
                                    prefixIcon: Icon(Icons.tag, color: AppColors.primaryColor),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      _correctNumber = int.tryParse(val);
                                    });
                                  },
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (_selectedLessonOid == null ||
                                  _selectedMethod == null ||
                                  (_selectedMethod == 3 &&
                                      (_correctNumber == null ||
                                          _correctNumber! <= 0)) ||
                                  isLoading)
                              ? null
                              : () {
                                  context.read<StartAttendanceCubit>().startSession(
                                        classOid: currentClass.oid,
                                        method: _selectedMethod!,
                                        lessonOid: _selectedLessonOid,
                                        correctNumber: _correctNumber ?? 0,
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                            disabledBackgroundColor: AppColors.grey.withValues(alpha: 0.2),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: (_selectedLessonOid == null || _selectedMethod == null || isLoading) ? 0 : 8,
                            shadowColor: AppColors.secondaryColor.withValues(alpha: 0.4),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  _buttonLabel,
                                  style: AppTextStyle.semiBold16.copyWith(
                                    color: _selectedMethod == null ? AppColors.grey : Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
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

    final anyStudentHasTodayRecord = teacherClass.students.any(
      (s) => s.details.attendance.recentRecords
          .any((r) => r.date.startsWith(todayStr)),
    );

    if (!anyStudentHasTodayRecord) return taken;

    // Only mark lessons that are scheduled TODAY
    for (final lesson in lessons) {
      if (lesson.date.startsWith(todayStr)) {
        taken.add(lesson.oid);
      }
    }
    return taken;
  }

  Widget _buildMethodRow({
    required int methodValue,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedMethod == methodValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = methodValue;
          if (methodValue != 3) _correctNumber = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCirc,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.lightGrey.withValues(alpha: 0.3),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? AppColors.primaryColor.withValues(alpha: 0.12) 
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: isSelected ? 16 : 8,
              offset: Offset(0, isSelected ? 6 : 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor.withValues(alpha: 0.1) : const Color(0xffF4F7FB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                size: 28,
                color: isSelected ? AppColors.primaryColor : AppColors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.bold16.copyWith(
                      color: isSelected ? AppColors.primaryColor : AppColors.black,
                      fontSize: 16,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: AppTextStyle.medium12.copyWith(
                      color: AppColors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCirc,
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primaryColor : AppColors.lightGrey.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
