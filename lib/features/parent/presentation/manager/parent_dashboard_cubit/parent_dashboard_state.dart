import 'package:school_system/features/parent/data/models/parent_dashboard_model.dart';
import 'package:school_system/core/api/api_errors.dart';

class ParentDashboardState {}

class ParentDashboardInitial extends ParentDashboardState {}

class ParentDashboardLoading extends ParentDashboardState {}

class ParentDashboardSuccess extends ParentDashboardState {
  final ParentDashboardModel data;

  ParentDashboardSuccess(this.data);
}

class ParentDashboardFailure extends ParentDashboardState {
  final ApiErrors error;

  ParentDashboardFailure(this.error);
}

class ParentChildrenSuccess extends ParentDashboardState {
  final List<ParentChildModel> children;

  ParentChildrenSuccess(this.children);
}