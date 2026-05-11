import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';
import 'package:school_system/features/parent/presentation/manager/parent_dashboard_cubit/parent_dashboard_cubit.dart';
import 'package:school_system/features/parent/presentation/manager/parent_dashboard_cubit/parent_dashboard_state.dart';
import 'package:school_system/features/parent/presentation/views/widgets/child_card.dart';
import 'package:school_system/features/parent/presentation/views/parent_my_kids_view.dart';

class ParentChildrenListView extends StatelessWidget {
  const ParentChildrenListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParentDashboardCubit(ParentDashboardRepo(ApiService()))..fetchChildren(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          title: Text(
            'My Children',
            style: AppTextStyle.bold18.copyWith(color: AppColors.darkBlue),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ParentDashboardCubit, ParentDashboardState>(
          builder: (context, state) {
            if (state is ParentDashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ParentDashboardFailure) {
              return Center(child: Text(state.error.errorMessage));
            } else if (state is ParentChildrenSuccess) {
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<ParentDashboardCubit>().fetchChildren();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: state.children.length,
                  itemBuilder: (context, index) {
                    final child = state.children[index];
                    return ChildCard(
                      name: child.name,
                      grade: 'Grade ${child.gradeLevel}',
                      gpa: child.gpa,
                      attendance: child.attendance,
                      subjectsCount: child.subjectsCount,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ParentMyKidsView.routeName,
                          arguments: child,
                        );
                      },
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
