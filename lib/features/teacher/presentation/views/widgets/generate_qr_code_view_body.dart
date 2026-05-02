import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/theme_manager.dart';
import 'package:school_system/features/teacher/data/models/attendance_session_model.dart';

class GenerateQrCodeViewBody extends StatefulWidget {
  final AttendanceSessionModel session;
  final bool isLoading;

  const GenerateQrCodeViewBody({
    super.key,
    required this.session,
    this.isLoading = false,
  });

  @override
  State<GenerateQrCodeViewBody> createState() => _GenerateQrCodeViewBodyState();
}

class _GenerateQrCodeViewBodyState extends State<GenerateQrCodeViewBody> {
  late final List<Map<String, dynamic>> _students;
  String? _lastScannedName;

  @override
  void initState() {
    super.initState();
    _students = widget.session.students.map((s) {
      return {'oid': s.studentOid, 'name': s.studentName, 'scanned': false};
    }).toList();
  }

  int get _total => _students.length;
  int get _presentCount => _students.where((s) => s['scanned'] == true).length;
  int get _pendingCount => _total - _presentCount;

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

                  // Live feedback banner for scans
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _lastScannedName != null
                        ? Container(
                            key: ValueKey(_lastScannedName),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xff065AD8,
                              ).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(
                                  0xff065AD8,
                                ).withValues(alpha: 0.25),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xff065AD8),
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '$_lastScannedName scanned in',
                                    style: AppTextStyle.medium14.copyWith(
                                      color: const Color(0xff065AD8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 24),

                  // Dynamic Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildBottomStatCard(
                          '$_presentCount/$_total',
                          'STUDENTS\nPRESENT',
                          AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildBottomStatCard(
                          _pendingCount.toString().padLeft(2, '0'),
                          'PENDING',
                          const Color(0xff993300),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Student scan list
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SCAN STATUS',
                      style: AppTextStyle.bold12.copyWith(
                        color: AppColors.grey,
                        letterSpacing: 1.2,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(_students.length, (index) {
                    final student = _students[index];
                    final bool scanned = student['scanned'] as bool;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: scanned
                              ? const Color(0xff065AD8).withValues(alpha: 0.3)
                              : AppColors.lightGrey.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: scanned
                                  ? const Color(0xff065AD8)
                                  : AppColors.lightGrey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              student['name'] as String,
                              style: AppTextStyle.medium14.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          Text(
                            scanned ? 'Scanned' : 'Pending',
                            style: AppTextStyle.bold12.copyWith(
                              color: scanned
                                  ? const Color(0xff065AD8)
                                  : AppColors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getExpirationText() {
    if (widget.session.expiresAt == null) return 'No Expiration';
    try {
      final expiry = DateTime.parse(widget.session.expiresAt!);
      final diff = expiry.difference(DateTime.now());
      if (diff.isNegative) return 'Expired';
      return '${diff.inMinutes}m remaining';
    } catch (_) {
      return 'Active';
    }
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

  Widget _buildBottomStatCard(String value, String label, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: ThemeManager.isDarkMode
            ? AppColors.lightGrey.withValues(alpha: 0.2)
            : const Color(0xffF4F7FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyle.bold24.copyWith(
              color: valueColor,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyle.bold12.copyWith(
              color: AppColors.grey,
              letterSpacing: 1.0,
              fontSize: 10,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
