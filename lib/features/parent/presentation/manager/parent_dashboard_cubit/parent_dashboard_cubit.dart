import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';
import 'parent_dashboard_state.dart';

class ParentDashboardCubit extends Cubit<ParentDashboardState> {
  final ParentDashboardRepo _repo;

  ParentDashboardCubit(this._repo) : super(ParentDashboardInitial());

  Future<void> fetchDashboard() async {
    emit(ParentDashboardLoading());
    final result = await _repo.getDashboard();
    result.fold(
      (error) => emit(ParentDashboardFailure(error)),
      (data) => emit(ParentDashboardSuccess(data)),
    );
  }

  Future<void> fetchChildren() async {
    emit(ParentDashboardLoading());
    final result = await _repo.getChildren();
    result.fold(
      (error) => emit(ParentDashboardFailure(error)),
      (children) => emit(ParentChildrenSuccess(children)),
    );
  }
}