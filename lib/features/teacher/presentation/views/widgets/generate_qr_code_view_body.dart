import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/theme_manager.dart';
import 'package:school_system/features/teacher/data/models/attendance_session_model.dart';
import 'package:school_system/features/teacher/data/models/session_tracking_model.dart';
import 'package:school_system/features/teacher/data/repos/attendance_repo.dart';

class GenerateQrCodeViewBody extends StatefulWidget {
  final AttendanceSessionModel session;
  final bool isLoading;
  final bool isSubmitting;
  final VoidCallback? onSubmit;

  const GenerateQrCodeViewBody({
    super.key,
    required this.session,
    this.isLoading = false,
    this.isSubmitting = false,
    this.onSubmit,
  });

  @override
  State<GenerateQrCodeViewBody> createState() => _GenerateQrCodeViewBodyState();
}

class _GenerateQrCodeViewBodyState extends State<GenerateQrCodeViewBody> {
  late AttendanceRepo _repo;
  SessionTrackingModel? _sessionDetail;
  bool _isSessionCompleted = false;
  bool _isSessionExpired = false;
  Timer? _pollTimer;
  Timer? _expiryTimer;

  @override
  void initState() {
    super.initState();
    _repo = AttendanceRepo(ApiService());

    _poll();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _poll());
    _expiryTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _expiryTimer?.cancel();
    super.dispose();
  }

  Future<void> _poll() async {
    if (_isSessionCompleted) return;

    final detailResult = await _repo.getSessionDetail(widget.session.sessionId);
    detailResult.fold(
      (_) {},
      (detail) {
        if (!mounted) return;
        setState(() {
          _sessionDetail = detail;
          if (detail.notRecorded == 0) {
            _isSessionCompleted = true;
            _pollTimer?.cancel();
          }
        });
      },
    );

    // Check if session is expired
    final sessionsResult = await _repo.getSessions(widget.session.classOid);
    sessionsResult.fold(
      (_) {},
      (sessions) {
        if (!mounted) return;
        try {
          final currentSession = sessions.firstWhere(
              (s) => s['sessionId'] == widget.session.sessionId,
              orElse: () => null);
          if (currentSession != null) {
            bool isCompleted = currentSession['isCompleted'] ?? false;
            bool isExpired = currentSession['isExpired'] ?? false;
            setState(() {
              if (isCompleted) {
                _isSessionCompleted = true;
                _pollTimer?.cancel();
              } else if (isExpired) {
                _isSessionExpired = true;
                _pollTimer?.cancel();
              }
            });
          }
        } catch (_) {}
      },
    );
  }

  int get _presentCount => _sessionDetail?.presentCount ?? 0;
  int get _absentCount => _sessionDetail?.absentCount ?? 0;
  int get _lateCount => _sessionDetail?.lateCount ?? 0;
  int get _pendingCount => _sessionDetail?.notRecorded ?? widget.session.students.length;

  String _getExpirationText() {
    if (widget.session.expiresAt == null) return 'No Expiration';
    try {
      final expiry = DateTime.parse(widget.session.expiresAt!);
      final diff = expiry.difference(DateTime.now());
      if (diff.isNegative) return 'Expired';
      final m = diff.inMinutes;
      final s = diff.inSeconds % 60;
      return '${m}m ${s}s remaining';
    } catch (_) {
      return 'Active';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: widget.isLoading,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Active Session Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffDDE4FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'ACTIVE SESSION',
                      style: AppTextStyle.bold12.copyWith(
                        color: const Color(0xff065AD8),
                        letterSpacing: 1.0,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    widget.session.className,
                    style: AppTextStyle.bold24.copyWith(
                      color: AppColors.black,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.session.lessonName,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.medium18.copyWith(
                      color: AppColors.primaryColor,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date and Time Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDateTimeItem(
                        Icons.calendar_today_outlined,
                        'Current Session',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: 1,
                          height: 30,
                          color: AppColors.lightGrey,
                        ),
                      ),
                      _buildDateTimeItem(
                        Icons.access_time,
                        _getExpirationText(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // QR Code Container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: ThemeManager.isDarkMode
                            ? AppColors.lightGrey.withValues(alpha: 0.2)
                            : const Color(0xffF4F7FB),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: widget.session.qrCodeBase64 != null
                          ? Image.memory(
                              base64Decode(widget.session.qrCodeBase64!),
                              width: 200,
                              height: 200,
                              fit: BoxFit.contain,
                            )
                          : const Icon(
                              Icons.qr_code,
                              size: 200,
                              color: Colors.grey,
                            ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    'Attendance QR Active',
                    style: AppTextStyle.bold16.copyWith(
                      color: AppColors.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Show this code to your students for them to mark their attendance. This code is dynamic and will update automatically.',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.medium14.copyWith(
                        color: AppColors.grey,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Live feedback banner for session completion / expiration
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _isSessionCompleted
                        ? _buildBanner('All students checked in', Colors.green, Icons.check_circle)
                        : _isSessionExpired
                            ? _buildBanner('Session expired', Colors.red, Icons.error)
                            : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 24),

                  // Live Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCounter('✅', 'Present', _presentCount, Colors.green),
                      _buildCounter('⏰', 'Late', _lateCount, Colors.amber),
                      _buildCounter('❌', 'Absent', _absentCount, Colors.red),
                      _buildCounter('○', 'Waiting', _pendingCount, Colors.grey),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Student scan list
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'STUDENT STATUS',
                      style: AppTextStyle.bold12.copyWith(
                        color: AppColors.grey,
                        letterSpacing: 1.2,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(_sessionDetail?.students.length ?? 0, (index) {
                    final student = _sessionDetail!.students[index];
                    return _buildStudentCard(student);
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── Submit Session Button ──────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      (widget.isSubmitting || (_isSessionExpired && !_isSessionCompleted))
                          ? null
                          : () {
                              widget.onSubmit?.call();
                            },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: widget.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Submit Session',
                          style: AppTextStyle.semiBold16.copyWith(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.grey),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyle.medium12.copyWith(
            color: AppColors.grey,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildBanner(String text, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.medium14.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(String icon, String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$icon $count',
          style: AppTextStyle.bold16.copyWith(color: color, fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyle.bold12.copyWith(color: AppColors.grey),
        ),
      ],
    );
  }

  Widget _buildStudentCard(SessionTrackingStudentModel student) {
    Color statusColor;
    IconData statusIcon;
    switch (student.status) {
      case 'Present':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Late':
        statusColor = Colors.amber;
        statusIcon = Icons.access_time;
        break;
      case 'Absent':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.pause_circle_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: statusColor.withValues(alpha: 0.1),
            child: Text(
              student.studentName.isNotEmpty ? student.studentName[0] : '?',
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.studentName,
                  style: AppTextStyle.medium14.copyWith(color: AppColors.black),
                ),
                if (student.checkInTime != null)
                  Text(
                    student.checkInTime!,
                    style: AppTextStyle.medium12.copyWith(color: AppColors.grey),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(statusIcon, size: 14, color: statusColor),
                const SizedBox(width: 4),
                Text(
                  student.status,
                  style: AppTextStyle.bold12.copyWith(color: statusColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
