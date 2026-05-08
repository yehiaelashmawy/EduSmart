import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';

class LessonInfoCard extends StatelessWidget {
  final TeacherLessonModel lesson;
  final bool isTaken;
  final String className;
  final String Function(String) formatDate;
  final String Function(String) formatTime;
  final bool isSelected;

  const LessonInfoCard({
    super.key,
    required this.lesson,
    required this.isTaken,
    required this.className,
    required this.formatDate,
    required this.formatTime,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: isSelected ? 1.02 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: isTaken ? const Color(0xff1E3A2F) : null,
          gradient: isTaken
              ? null
              : LinearGradient(
                  colors: [AppColors.secondaryColor, const Color(0xff1a3f8f)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Colors.white, width: 2.5)
              : Border.all(color: Colors.transparent, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: (isTaken
                      ? const Color(0xff1E3A2F)
                      : AppColors.secondaryColor)
                  .withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (isTaken)
              Positioned(
                right: -10,
                top: -10,
                child: Opacity(
                  opacity: 0.08,
                  child: const Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: status chip + icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isTaken
                              ? const Color(0xff059669).withValues(alpha: 0.8)
                              : Colors.white.withValues(alpha: 0.2),
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
                      const Spacer(),
                      if (isTaken)
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.refresh_rounded,
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
                      InfoChip(
                        icon: Icons.calendar_today_rounded,
                        label: formatDate(lesson.date),
                      ),
                      if (lesson.startTime.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        InfoChip(
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
                            Icons.info_outline,
                            color: Colors.white70,
                            size: 12,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Re-submitting overwrites records',
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
          ],
        ),
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const InfoChip({super.key, required this.icon, required this.label});

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
