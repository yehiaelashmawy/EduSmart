import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/presentation/views/widgets/parent_payments_view_body.dart';

class ParentPaymentsView extends StatelessWidget {
  static const routeName = 'parent_payments_view';
  const ParentPaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        titleSpacing: 8,
        title: Text(
          'School Payments',
          style: AppTextStyle.bold20.copyWith(color: AppColors.primaryColor),
        ),
        centerTitle: false,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
      body: const ParentPaymentsViewBody(),
    );
  }
}
