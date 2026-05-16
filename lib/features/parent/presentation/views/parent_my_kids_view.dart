import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/data/models/parent_dashboard_model.dart';
import 'package:school_system/features/parent/presentation/views/widgets/parent_my_kids_view_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/parent/presentation/manager/children_dashboard_cubit/children_dashboard_cubit.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';
import 'package:school_system/core/api/api_service.dart';

class ParentMyKidsView extends StatelessWidget {
  final ParentChildModel? child;
  const ParentMyKidsView({super.key, this.child});
  static const String routeName = 'parent_my_kids_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChildrenDashboardCubit(ParentDashboardRepo(ApiService()))..getChildrenDashboard(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            child?.name ?? 'Child Details',
            style: AppTextStyle.bold18.copyWith(color: AppColors.darkBlue),
          ),
        ),
        body: ParentMyKidsViewBody(child: child),
      ),
    );
  }
}
