import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/theme_manager.dart';
import 'package:school_system/features/teacher/data/models/attendance_session_model.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/code_selector_card.dart';

class EntryCodeViewBody extends StatefulWidget {
  final AttendanceSessionModel session;
  final bool isLoading;

  const EntryCodeViewBody({
    super.key,
    required this.session,
    this.isLoading = false,
  });

  @override
  State<EntryCodeViewBody> createState() => _EntryCodeViewBodyState();
}

class _EntryCodeViewBodyState extends State<EntryCodeViewBody> {
  late final List<Map<String, dynamic>> _students;
  String? _lastScannedName;
  int _activeCodeIndex = 0;

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
    final List<String> codes =
        widget.session.randomNumbers
            ?.map((e) => e.toString().padLeft(2, '0'))
            .toList() ??
        ['00', '00', '00'];

    return Skeletonizer(
      enabled: widget.isLoading,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 28),
                  CodeSelectorCard(
                    codes: codes,
                    activeIndex: _activeCodeIndex,
                    onSelect: (i) => setState(() => _activeCodeIndex = i),
                  ),
                  const SizedBox(height: 32),
                  _SectionDivider(),
                  const SizedBox(height: 24),

                  // Session info
                  Text(
                    'SESSION DETAILS',
                    style: AppTextStyle.bold12.copyWith(
                      color: AppColors.grey,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.lightGrey.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xffDDE4FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.school_outlined,
                            color: Color(0xff065AD8),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.session.className,
                                style: AppTextStyle.bold16.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.session.lessonName,
                                style: AppTextStyle.medium14.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Live feedback banner for entries
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _lastScannedName != null
                        ? Container(
                            key: ValueKey(_lastScannedName),
                            margin: const EdgeInsets.only(bottom: 24),
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
                                    '$_lastScannedName matched the code',
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

                  // Stats Row
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

                  const SizedBox(height: 32),

                  // Student list
                  Text(
                    'STUDENT STATUS',
                    style: AppTextStyle.bold12.copyWith(
                      color: AppColors.grey,
                      letterSpacing: 1.0,
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
                            scanned ? 'Joined' : 'Waiting',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live Attendance Session',
          style: AppTextStyle.bold16.copyWith(
            color: AppColors.black,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: AppTextStyle.medium14.copyWith(
              color: AppColors.grey,
              height: 1.5,
            ),
            children: [
              const TextSpan(
                text:
                    'Please select the correct code for students to match in their ',
              ),
              TextSpan(
                text: 'Academic Curator',
                style: AppTextStyle.medium14.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              const TextSpan(text: ' app.'),
            ],
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

class _SectionDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.lightGrey.withValues(alpha: 0.4),
      thickness: 1,
      height: 1,
    );
  }
}
