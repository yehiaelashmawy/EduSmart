import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/data/models/parent_attendance_model.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';
import 'package:school_system/features/parent/presentation/manager/child_attendance_cubit/child_attendance_cubit.dart';
import 'package:school_system/features/parent/presentation/manager/child_attendance_cubit/child_attendance_state.dart';
import 'package:school_system/features/parent/presentation/views/widgets/kid_section_header.dart';
import 'package:skeletonizer/skeletonizer.dart';

class KidAttendanceTab extends StatelessWidget {
  final String? childId;
  const KidAttendanceTab({super.key, this.childId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChildAttendanceCubit(
        ParentDashboardRepo(ApiService()),
        childId: childId ?? '',
      )..fetchAttendance(),
      child: const _KidAttendanceTabContent(),
    );
  }
}

class _KidAttendanceTabContent extends StatelessWidget {
  const _KidAttendanceTabContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildAttendanceCubit, ChildAttendanceState>(
      builder: (context, state) {
        if (state is ChildAttendanceLoading) {
          return Skeletonizer(
            enabled: true,
            child: _AttendanceContent(
              data: ChildAttendanceModel(
                studentOid: '',
                studentName: 'Student Name',
                gradeLevel: 'Grade',
                gpa: 0,
                attendance: 0,
                subjectsCount: 0,
                attendanceStats: AttendanceStatsModel(
                  overallAttendancePercentage: 80,
                  totalPresentDays: 0,
                  totalAbsentDays: 0,
                  totalLateDays: 0,
                  recentRecords: List.generate(
                    5,
                    (index) => AttendanceRecordModel(
                      date: DateTime.now(),
                      dayName: 'Day Name',
                      status: 'Present',
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (state is ChildAttendanceFailure) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            child: Center(
              child: Text(
                state.error.errorMessage,
                style: AppTextStyle.medium14.copyWith(color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (state is ChildAttendanceSuccess) {
          return _AttendanceContent(data: state.data);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _AttendanceContent extends StatelessWidget {
  final ChildAttendanceModel data;
  const _AttendanceContent({required this.data});

  @override
  Widget build(BuildContext context) {
    final stats = data.attendanceStats;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary stats row
          _AttendanceSummaryRow(stats: stats),
          const SizedBox(height: 24),
          const KidSectionHeader(
            icon: Icons.history_rounded,
            title: 'Recent Records',
          ),
          const SizedBox(height: 16),
          _RecentRecordsList(records: stats.recentRecords),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _AttendanceSummaryRow extends StatelessWidget {
  final AttendanceStatsModel stats;
  const _AttendanceSummaryRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Overall percentage card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Attendance',
                    style: AppTextStyle.medium14.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${stats.overallAttendancePercentage.toStringAsFixed(1)}%',
                    style: AppTextStyle.bold30.copyWith(color: Colors.white),
                  ),
                ],
              ),
              const Spacer(),
              _buildCircle(stats.overallAttendancePercentage / 100),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Three stat cards
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.check_circle_rounded,
                label: 'Present',
                value: stats.totalPresentDays.toString(),
                color: const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.cancel_rounded,
                label: 'Absent',
                value: stats.totalAbsentDays.toString(),
                color: const Color(0xFFF44336),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.watch_later_rounded,
                label: 'Late',
                value: stats.totalLateDays.toString(),
                color: const Color(0xFFFF9800),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircle(double progress) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            color: Colors.white,
            strokeWidth: 6,
          ),
          Center(
            child: Icon(
              Icons.person_rounded,
              color: Colors.white.withValues(alpha: 0.8),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyle.bold20.copyWith(color: AppColors.darkBlue),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}

class _RecentRecordsList extends StatelessWidget {
  final List<AttendanceRecordModel> records;
  const _RecentRecordsList({required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Center(
        child: Text(
          'No recent records available',
          style: AppTextStyle.medium14.copyWith(color: AppColors.grey),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: records.asMap().entries.map((entry) {
          final record = entry.value;
          final isLast = entry.key == records.length - 1;
          final formattedDate = DateFormat('MMM d, yyyy').format(record.date);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.06),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.calendar_today_rounded,
                        size: 18,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.dayName,
                            style: AppTextStyle.bold14.copyWith(
                              color: AppColors.darkBlue,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formattedDate,
                            style: AppTextStyle.regular12.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _AttendanceChip(status: record.status),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  color: AppColors.grey.withValues(alpha: 0.08),
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _AttendanceChip extends StatelessWidget {
  final String status;
  const _AttendanceChip({required this.status});

  Color get _bgColor {
    switch (status) {
      case 'Present':
        return const Color(0xFFE8F5E9);
      case 'Late':
        return const Color(0xFFFFF3E0);
      case 'Absent':
        return const Color(0xFFFFEBEE);
      default:
        return AppColors.lightGrey;
    }
  }

  Color get _textColor {
    switch (status) {
      case 'Present':
        return const Color(0xFF4CAF50);
      case 'Late':
        return const Color(0xFFFF9800);
      case 'Absent':
        return const Color(0xFFF44336);
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppTextStyle.bold12.copyWith(color: _textColor, fontSize: 11),
      ),
    );
  }
}
