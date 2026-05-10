import 'dart:async';
import 'package:flutter/material.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/active_session_model.dart';
import 'package:school_system/features/student/data/repos/student_attendance_repo.dart';
import 'package:school_system/features/student/presentation/views/student_select_code_view.dart';

class ActiveSessionBanner extends StatefulWidget {
  const ActiveSessionBanner({super.key});

  @override
  State<ActiveSessionBanner> createState() => _ActiveSessionBannerState();
}

class _ActiveSessionBannerState extends State<ActiveSessionBanner>
    with SingleTickerProviderStateMixin {
  final StudentAttendanceRepo _repo = StudentAttendanceRepo(ApiService());

  ActiveSessionModel? _session;
  bool _checking = true;
  Timer? _expiryTimer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fetchSession();

    // Re-check every 15 seconds
    _expiryTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _fetchSession(),
    );
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _fetchSession() async {
    final result = await _repo.getActiveSession();
    if (!mounted) return;
    result.fold(
      (_) => setState(() {
        _session = null;
        _checking = false;
      }),
      (session) => setState(() {
        _session = session;
        _checking = false;
      }),
    );
  }

  String _methodLabel(int method) {
    switch (method) {
      case 2:
        return 'Scan QR Code';
      case 3:
        return 'Enter Code';
      default:
        return 'Manual';
    }
  }

  String _countdown(String expiresAt) {
    try {
      final expiry = DateTime.parse(expiresAt);
      final diff = expiry.difference(DateTime.now());
      if (diff.isNegative) return 'Expired';
      final m = diff.inMinutes;
      final s = diff.inSeconds % 60;
      return '${m}m ${s}s left';
    } catch (_) {
      return 'Active';
    }
  }

  void _navigate() {
    final session = _session;
    if (session == null) return;
    if (session.method == 2) {
      Navigator.pushNamed(
        context,
        'student_scan_qr_view',
        arguments: session.className,
      );
    } else if (session.method == 3) {
      Navigator.pushNamed(context, StudentSelectCodeView.routeName);
    }
    // method == 1 → manual, teacher-only, no student action
  }

  @override
  Widget build(BuildContext context) {
    // Nothing to show while checking or when no session
    if (_checking || _session == null || _session!.method == 1) {
      return const SizedBox.shrink();
    }

    final session = _session!;

    return GestureDetector(
      onTap: _navigate,
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.secondaryColor, const Color(0xff1a3f8f)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondaryColor.withValues(
                    alpha: 0.3 * _pulseAnim.value,
                  ),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(18),
            child: child,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Pulsing dot
                AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, _) => Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: _pulseAnim.value),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'ATTENDANCE SESSION LIVE',
                  style: AppTextStyle.bold12.copyWith(
                    color: Colors.white,
                    letterSpacing: 1.0,
                    fontSize: 10,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _countdown(session.expiresAt),
                    style: AppTextStyle.bold12.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              session.className,
              style: AppTextStyle.bold18.copyWith(
                color: Colors.white,
                fontSize: 20,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              _methodLabel(session.method),
              style: AppTextStyle.medium14.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    session.method == 2 ? Icons.qr_code_scanner : Icons.pin,
                    color: AppColors.secondaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    session.method == 2
                        ? 'Tap to Scan QR'
                        : 'Tap to Enter Code',
                    style: AppTextStyle.semiBold14.copyWith(
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
