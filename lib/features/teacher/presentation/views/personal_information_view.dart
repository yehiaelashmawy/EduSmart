import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/personal_information_view_body.dart';

class PersonalInformationView extends StatelessWidget {
  const PersonalInformationView({super.key});
  static const String routeName = 'PersonalInformationView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Personal Information',
          style: AppTextStyle.bold16.copyWith(
            color: AppColors.darkBlue,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: const PersonalInformationViewBody(),
    );
  }
}
