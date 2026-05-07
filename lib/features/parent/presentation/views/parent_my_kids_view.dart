import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/presentation/views/widgets/parent_my_kids_view_body.dart';

class ParentMyKidsView extends StatelessWidget {
  const ParentMyKidsView({super.key});
  static const String routeName = 'parent_my_kids_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Center(
          child: Text(
            'Child Details',

            style: AppTextStyle.bold18.copyWith(color: AppColors.darkBlue),
          ),
        ),
      ),
      body: const ParentMyKidsViewBody(),
    );
  }
}
