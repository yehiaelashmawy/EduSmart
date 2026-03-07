import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_images.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/on_broding/presentation/views/on_bording_view.dart';
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
          const Text('EduSmart', style: AppTextStyle.bold32),
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
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, OnBordingView.routeName);
    });
  }
}
