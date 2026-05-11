import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';
import 'package:school_system/features/parent/presentation/manager/parent_payments_cubit/parent_payments_cubit.dart';
import 'package:school_system/features/parent/presentation/views/widgets/parent_payments_view_body.dart';

class ParentPaymentsView extends StatelessWidget {
  static const routeName = 'parent_payments_view';
  const ParentPaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ParentPaymentsCubit(ParentDashboardRepo(ApiService()))
            ..fetchPaymentSummary(),
      child: Scaffold(
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
      ),
    );
  }
}
