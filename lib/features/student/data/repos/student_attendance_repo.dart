import 'package:dartz/dartz.dart';
import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/features/student/data/models/active_session_model.dart';

class StudentAttendanceRepo {
  final ApiService _apiService;

  StudentAttendanceRepo(this._apiService);

  Future<Either<ApiErrors, ActiveSessionModel>> getActiveSession() async {
    try {
      final response = await _apiService.get('/api/Attendance/active-session');

      final success = response['success'] as bool? ?? false;
      final data = response['data'];

      if (success && data != null) {
        return Right(
          ActiveSessionModel.fromJson((data as Map).cast<String, dynamic>()),
        );
      } else {
        return Left(
          ApiErrors(
            errorMessage:
                response['messages']?['Error'] ?? 'No active session found',
          ),
        );
      }
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, bool>> submitAttendance({
    required String sessionId,
    required int selectedNumber,
    required String remarks,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/Attendance/student-submit',
        data: {
          'sessionId': sessionId,
          'selectedNumber': selectedNumber,
          'remarks': remarks,
        },
      );

      final success = response['success'] as bool? ?? false;

      if (success) {
        return const Right(true);
      } else {
        return Left(
          ApiErrors(
            errorMessage:
                response['messages']?['Error'] ?? 'Failed to submit attendance',
          ),
        );
      }
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }
}
