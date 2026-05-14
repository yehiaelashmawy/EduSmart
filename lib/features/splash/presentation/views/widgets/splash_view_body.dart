import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_images.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/helper/shared_prefs_helper.dart';
import 'package:school_system/features/on_broding/presentation/views/on_bording_view.dart';
import 'package:school_system/features/Auth/presentation/views/auth_view.dart';
import 'package:school_system/features/student/presentation/views/student_home_view.dart';
import 'package:school_system/features/teacher/presentation/views/teacher_home_view.dart';
import 'package:school_system/features/parent/presentation/views/parent_home_view.dart';
import 'package:svg_flutter/svg.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with TickerProviderStateMixin {
  // ── Entrance (once) ──────────────────────────────────────────
  late AnimationController _entranceCtrl;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _subtitleFade;
  late Animation<double> _dotsFade;

  // ── Repeating ────────────────────────────────────────────────
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmer;

  late AnimationController _dotsCtrl;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _executeNavigation();
  }

  void _initAnimations() {
    // ── Entrance 1.6s ─────────────────────────────────────────
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceCtrl,
            curve: const Interval(0.35, 0.72, curve: Curves.easeOutCubic),
          ),
        );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.35, 0.65, curve: Curves.easeIn),
      ),
    );
    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceCtrl,
            curve: const Interval(0.55, 0.90, curve: Curves.easeOutCubic),
          ),
        );
    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.55, 0.85, curve: Curves.easeIn),
      ),
    );
    _dotsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.78, 1.0, curve: Curves.easeIn),
      ),
    );
    _entranceCtrl.forward();

    // ── Pulsing glow on logo ──────────────────────────────────
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    // ── Shimmer sweep across logo ─────────────────────────────
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _shimmer = Tween<double>(
      begin: -1.5,
      end: 2.5,
    ).animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));

    // ── Loading dots ──────────────────────────────────────────
    _dotsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _pulseCtrl.dispose();
    _shimmerCtrl.dispose();
    _dotsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _entranceCtrl,
        _pulseCtrl,
        _shimmerCtrl,
        _dotsCtrl,
      ]),
      builder: (context, _) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.backgroundColor,
          child: Stack(
            children: [
              // Decorative blurred orbs using primary color
              _buildOrb(top: -100, right: -60, size: 280),
              _buildOrb(bottom: 40, left: -80, size: 300),
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(),
                    const SizedBox(height: 40),
                    _buildTitle(),
                    const SizedBox(height: 10),
                    _buildSubtitle(),
                    const SizedBox(height: 64),
                    _buildLoadingDots(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Decorative blurred orb ────────────────────────────────────
  Widget _buildOrb({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.primaryColor.withValues(alpha: 0.10),
              AppColors.primaryColor.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }

  // ── Logo ──────────────────────────────────────────────────────
  Widget _buildLogo() {
    return FadeTransition(
      opacity: _logoFade,
      child: ScaleTransition(
        scale: _logoScale,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Soft pulsing glow behind logo
            AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (_, _) => Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(
                        alpha: 0.18 * _pulse.value,
                      ),
                      blurRadius: 48,
                      spreadRadius: 14 * _pulse.value,
                    ),
                  ],
                ),
              ),
            ),
            // Logo — no circle, just the SVG with shimmer
            ShaderMask(
              shaderCallback: (rect) => LinearGradient(
                begin: Alignment(_shimmer.value - 1, -0.3),
                end: Alignment(_shimmer.value, 0.3),
                colors: [
                  Colors.transparent,
                  AppColors.primaryColor.withValues(alpha: 0.18),
                  Colors.transparent,
                ],
              ).createShader(rect),
              blendMode: BlendMode.srcATop,
              child: SvgPicture.asset(
                Assets.imagesAppLogo,
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Title ─────────────────────────────────────────────────────
  Widget _buildTitle() {
    return FadeTransition(
      opacity: _titleFade,
      child: SlideTransition(
        position: _titleSlide,
        child: Text(
          'EduSmart',
          style: AppTextStyle.bold32.copyWith(
            color: AppColors.primaryColor,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  // ── Subtitle ──────────────────────────────────────────────────
  Widget _buildSubtitle() {
    return FadeTransition(
      opacity: _subtitleFade,
      child: SlideTransition(
        position: _subtitleSlide,
        child: Text(
          'Your Intelligent Learning Companion',
          textAlign: TextAlign.center,
          style: AppTextStyle.medium18.copyWith(color: AppColors.grey),
        ),
      ),
    );
  }

  // ── Loading dots ──────────────────────────────────────────────
  Widget _buildLoadingDots() {
    return FadeTransition(
      opacity: _dotsFade,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          final t = (_dotsCtrl.value + i / 3.0) % 1.0;
          final scale = 0.5 + 0.5 * math.sin(t * math.pi);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.lerp(
                    AppColors.primaryColor.withValues(alpha: 0.25),
                    AppColors.primaryColor,
                    scale,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(
                        alpha: scale * 0.4,
                      ),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Navigation ────────────────────────────────────────────────
  void _executeNavigation() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      if (SharedPrefsHelper.isAuthenticated) {
        final role = SharedPrefsHelper.userRole;
        if (role == '3') {
          Navigator.pushReplacementNamed(context, StudentHomeView.routeName);
        } else if (role == '4') {
          Navigator.pushReplacementNamed(context, ParentHomeView.routeName);
        } else {
          Navigator.pushReplacementNamed(context, TeacherHomeView.routeName);
        }
      } else if (SharedPrefsHelper.hasSeenOnboarding) {
        Navigator.pushReplacementNamed(context, AuthView.routeName);
      } else {
        Navigator.pushReplacementNamed(context, OnBordingView.routeName);
      }
    });
  }
}
