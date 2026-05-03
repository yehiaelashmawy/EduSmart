import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/presentation/views/widgets/parent_secure_payment_view_body.dart';

class ParentSecurePaymentView extends StatelessWidget {
  static const routeName = 'parent_secure_payment_view';

  const ParentSecurePaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: Text(
          'School Payments',
          style: AppTextStyle.bold20.copyWith(color: AppColors.primaryColor),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
      body: const ParentSecurePaymentViewBody(),
    );
  }
}
