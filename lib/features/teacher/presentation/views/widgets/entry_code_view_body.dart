import 'dart:async';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/theme_manager.dart';
import 'package:school_system/features/teacher/data/models/attendance_session_model.dart';
import 'package:school_system/features/teacher/data/repos/attendance_repo.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/code_selector_card.dart';

class EntryCodeViewBody extends StatefulWidget {
  final AttendanceSessionModel session;
  final bool isLoading;
  final bool isSubmitting;
  // selectedNumber is the actual int value the teacher tapped
  final void Function(int selectedNumber)? onSubmit;

  const EntryCodeViewBody({
    super.key,
    required this.session,
    this.isLoading = false,
    this.isSubmitting = false,
    this.onSubmit,
  });

  @override
  State<EntryCodeViewBody> createState() => _EntryCodeViewBodyState();
}

class _EntryCodeViewBodyState extends State<EntryCodeViewBody> {
  late AttendanceRepo _repo;
  late List<Map<String, dynamic>> _students;
  String? _lastScannedName;
  int? _selectedNumber; // actual number value, not index
  int _activeCodeIndex = 0;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _repo = AttendanceRepo(ApiService());
    _students = widget.session.students.map((s) {
      return {'oid': s.studentOid, 'name': s.studentName, 'scanned': false};
    }).toList();

    // Poll every 5 seconds for real-time student join status
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _poll());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _poll() async {
    final result = await _repo.getActiveSession();
    result.fold(
      (_) {},
      (session) {
        if (!mounted) return;
        if (session.randomNumbers == null || session.randomNumbers!.isEmpty) return;
        
        final scannedOids = <String>{
          for (final s in session.students) s.studentOid,
        };
        setState(() {
          String? newScan;
          for (final student in _students) {
            final oid = student['oid'] as String;
            final wasScanned = student['scanned'] as bool;
            if (scannedOids.contains(oid) && !wasScanned) {
              student['scanned'] = true;
              newScan = student['name'] as String;
            }
          }
          if (newScan != null) _lastScannedName = newScan;
        });
      },
    );
  }

  int get _total => _students.length;
  int get _presentCount => _students.where((s) => s['scanned'] == true).length;
  int get _pendingCount => _total - _presentCount;

  @override
  Widget build(BuildContext context) {
    final List<int> randomNumbers = widget.session.randomNumbers ?? [];
    if (randomNumbers.isEmpty) {
      return Center(
        child: Text(
          'No codes received from server',
          style: AppTextStyle.medium16.copyWith(color: AppColors.grey),
        ),
      );
    }

    final List<String> codes =
        randomNumbers.map((e) => e.toString().padLeft(2, '0')).toList();

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

                  // ── Code Selector ────────────────────────────────────────
                  CodeSelectorCard(
                    codes: codes,
                    activeIndex: _activeCodeIndex,
                    onSelect: (i) {
                      setState(() {
                        _activeCodeIndex = i;
                        // Store the actual number value for the API call
                        _selectedNumber = randomNumbers.isNotEmpty
                            ? randomNumbers[i]
                            : null;
                      });
                    },
                  ),

                  if (_selectedNumber != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: Color(0xff059669),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Correct code set to $_selectedNumber',
                          style: AppTextStyle.medium12.copyWith(
                            color: const Color(0xff059669),
                          ),
                        ),
                      ],
                    ),
                  ],

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

                  // Live feedback banner
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
                              color: const Color(0xff065AD8).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xff065AD8).withValues(alpha: 0.25),
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

                  // Student status list
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Submit Button ────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_selectedNumber == null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Select the correct code above before submitting.',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.medium12.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_selectedNumber == null || widget.isSubmitting)
                          ? null
                          : () => widget.onSubmit?.call(_selectedNumber!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        disabledBackgroundColor:
                            AppColors.secondaryColor.withValues(alpha: 0.4),
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
                text: 'Select the correct code for students to match in their ',
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
