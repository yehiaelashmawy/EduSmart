import 'dart:async';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/attendance_session_model.dart';
import 'package:school_system/features/teacher/data/models/session_tracking_model.dart';
import 'package:school_system/features/teacher/data/repos/attendance_repo.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/code_selector_card.dart';

class EntryCodeViewBody extends StatefulWidget {
  final AttendanceSessionModel session;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  // selectedNumber is the actual int value the teacher tapped
  final void Function(int selectedNumber)? onSubmit;

  const EntryCodeViewBody({
    super.key,
    required this.session,
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.onSubmit,
  });

  @override
  State<EntryCodeViewBody> createState() => _EntryCodeViewBodyState();
}

class _EntryCodeViewBodyState extends State<EntryCodeViewBody> {
  late AttendanceRepo _repo;
  SessionTrackingModel? _sessionDetail;
  bool _isSessionCompleted = false;
  int? _selectedNumber; // actual number value, not index
  int _activeCodeIndex = 0;
  bool _isPolling = false;
  int _consecutiveErrors = 0;
  bool _showPollingError = false;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _repo = AttendanceRepo(ApiService());

    _startPolling();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _poll();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (_isPolling) return;
      _isPolling = true;
      try {
        await _poll();
      } finally {
        _isPolling = false;
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _poll() async {
    if (_isSessionCompleted) return;

    final result = await _repo.getSessionDetail(widget.session.sessionId);

    result.fold(
      (error) {
        _consecutiveErrors++;
        if (_consecutiveErrors >= 3) {
          _pollTimer?.cancel();
          if (!mounted) return;
          setState(() => _showPollingError = true);
        }
      },
      (detail) {
        _consecutiveErrors = 0;
        if (!mounted) return;
        setState(() {
          _sessionDetail = detail;
          _showPollingError = false;
          if (detail.notRecorded == 0) {
            _isSessionCompleted = true;
            _pollTimer?.cancel();
          }
        });
      },
    );
  }

  int get _presentCount => _sessionDetail?.presentCount ?? 0;
  int get _absentCount => _sessionDetail?.absentCount ?? 0;
  int get _lateCount => _sessionDetail?.lateCount ?? 0;
  int get _pendingCount =>
      _sessionDetail?.notRecorded ?? widget.session.students.length;

  bool get _isExpired {
    if (widget.session.expiresAt == null) return false;
    try {
      final expiry = DateTime.parse(widget.session.expiresAt!);
      return !_isSessionCompleted && DateTime.now().isAfter(expiry);
    } catch (_) {
      return false;
    }
  }

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

    final List<String> codes = randomNumbers
        .map((e) => e.toString().padLeft(2, '0'))
        .toList();

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

                  if (widget.errorMessage != null &&
                      widget.errorMessage!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.errorMessage!.contains('Invalid') ||
                                    widget.errorMessage!.contains('Wrong')
                                ? 'Wrong number, try again'
                                : widget.errorMessage!,
                            style: AppTextStyle.medium12.copyWith(
                              color: Colors.red,
                            ),
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
                    child: _isSessionCompleted
                        ? _buildBanner(
                            'All students checked in',
                            Colors.green,
                            Icons.check_circle,
                          )
                        : _isExpired
                        ? _buildBanner(
                            'Session expired',
                            Colors.red,
                            Icons.error,
                          )
                        : const SizedBox.shrink(),
                  ),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCounter(
                        '✅',
                        'Present',
                        _presentCount,
                        Colors.green,
                      ),
                      _buildCounter('⏰', 'Late', _lateCount, Colors.amber),
                      _buildCounter('❌', 'Absent', _absentCount, Colors.red),
                      _buildCounter('○', 'Waiting', _pendingCount, Colors.grey),
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
                  if (_showPollingError)
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.orange.shade50,
                      child: Row(
                        children: [
                          const Icon(Icons.wifi_off, color: Colors.orange),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Live updates paused. Check your connection.',
                              style: TextStyle(color: Colors.orange.shade800),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() => _showPollingError = false);
                              _consecutiveErrors = 0;
                              _startPolling();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  if (_showPollingError) const SizedBox(height: 16),
                  ...List.generate(_sessionDetail?.students.length ?? 0, (
                    index,
                  ) {
                    final student = _sessionDetail!.students[index];
                    return _buildStudentCard(student);
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
                      onPressed:
                          (_selectedNumber == null ||
                              widget.isSubmitting ||
                              (_isExpired && !_isSessionCompleted))
                          ? null
                          : () => widget.onSubmit?.call(_selectedNumber!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        disabledBackgroundColor: AppColors.secondaryColor
                            .withValues(alpha: 0.4),
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

  Widget _buildBanner(String text, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
        Text(label, style: AppTextStyle.bold12.copyWith(color: AppColors.grey)),
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
                    style: AppTextStyle.medium12.copyWith(
                      color: AppColors.grey,
                    ),
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
