import 'package:dartz/dartz.dart';
import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/features/parent/data/models/parent_dashboard_model.dart';
import 'package:school_system/features/parent/data/models/parent_attendance_model.dart';
import 'package:school_system/features/parent/data/models/parent_grades_model.dart';

class ParentDashboardRepo {
  final ApiService apiService;

  ParentDashboardRepo(this.apiService);

  Future<Either<ApiErrors, ParentDashboardModel>> getDashboard() async {
    try {
      final response = await apiService.get('/api/Parents/dashboard');
      final data = ParentDashboardModel.fromJson(response['data']);
      return Right(data);
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, List<ParentChildModel>>> getChildren() async {
    try {
      final response = await apiService.get('/api/Parents/my-children');
      final List childrenJson = response['data']['children'] ?? [];
      final children = childrenJson.map((e) => ParentChildModel.fromJson(e)).toList();
      return Right(children);
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }
  Future<Either<ApiErrors, ChildrenAttendanceModel>> getChildrenAttendance() async {
    try {
      final response = await apiService.get('/api/Parents/Children-Attendance');
      final data = ChildrenAttendanceModel.fromJson(response['data']);
      return Right(data);
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, List<ParentGradesModel>>> getGrades() async {
    try {
      final response = await apiService.get('/api/Parents/grades');
      final List dataJson = response['data'] ?? [];
      final data = dataJson.map((e) => ParentGradesModel.fromJson(e)).toList();
      return Right(data);
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }
}
