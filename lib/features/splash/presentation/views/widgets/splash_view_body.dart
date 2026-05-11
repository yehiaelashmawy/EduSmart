import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_images.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/on_broding/presentation/views/on_bording_view.dart';
import 'package:school_system/features/Auth/presentation/views/auth_view.dart';
import 'package:school_system/features/student/presentation/views/student_home_view.dart';
import 'package:school_system/features/teacher/presentation/views/teacher_home_view.dart';
import 'package:school_system/features/parent/presentation/views/parent_home_view.dart';
import 'package:school_system/core/helper/shared_prefs_helper.dart';
import 'package:svg_flutter/svg.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    excuteNavigation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Assets.imagesAppLogo),
          const SizedBox(height: 32),
          Text('EduSmart', style: AppTextStyle.bold32),
          const SizedBox(height: 8),
          Text(
            'Your Intelligent Learning Companion',
            style: AppTextStyle.medium18.copyWith(color: Color(0xff64748B)),
          ),
        ],
      ),
    );
  }

  void excuteNavigation() {
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
