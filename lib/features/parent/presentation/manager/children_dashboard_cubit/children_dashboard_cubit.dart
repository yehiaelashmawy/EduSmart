import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/features/parent/data/models/children_dashboard_model.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';

abstract class ChildrenDashboardState {}

class ChildrenDashboardInitial extends ChildrenDashboardState {}
class ChildrenDashboardLoading extends ChildrenDashboardState {}
class ChildrenDashboardSuccess extends ChildrenDashboardState {
  final ChildrenDashboardData data;
  ChildrenDashboardSuccess(this.data);
}
class ChildrenDashboardFailure extends ChildrenDashboardState {
  final ApiErrors error;
  ChildrenDashboardFailure(this.error);
}

class ChildrenDashboardCubit extends Cubit<ChildrenDashboardState> {
  final ParentDashboardRepo parentDashboardRepo;

  ChildrenDashboardCubit(this.parentDashboardRepo) : super(ChildrenDashboardInitial());

  Future<void> getChildrenDashboard() async {
    emit(ChildrenDashboardLoading());
    final result = await parentDashboardRepo.getChildrenDashboard();
    result.fold(
      (error) => emit(ChildrenDashboardFailure(error)),
      (data) => emit(ChildrenDashboardSuccess(data)),
    );
  }
}
