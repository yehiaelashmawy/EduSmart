import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:svg_flutter/svg.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/App Logo.svg'),
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
}
