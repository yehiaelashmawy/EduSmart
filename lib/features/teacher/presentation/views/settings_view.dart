import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/settings_view_body.dart';

import 'package:school_system/core/helper/localization_helper.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});
  static const String routeName = 'settings_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Slate 50
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.darkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'settings'.tr(),
          style: AppTextStyle.bold16.copyWith(
            color: AppColors.darkBlue,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: const SettingsViewBody(),
    );
  }
}
