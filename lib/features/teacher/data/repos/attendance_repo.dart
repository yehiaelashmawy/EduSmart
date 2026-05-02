import 'package:dartz/dartz.dart';
import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/features/teacher/data/models/attendance_session_model.dart';

class AttendanceRepo {
  final ApiService _apiService;

  AttendanceRepo(this._apiService);

  Future<Either<ApiErrors, AttendanceSessionModel>> startSession({
    required String classOid,
    required int method,
    String? lessonOid,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/Attendance/start-session',
        data: {'classOid': classOid, 'method': method, 'lessonOid': ?lessonOid},
      );

      final success = response['success'] as bool? ?? false;
      final data = response['data'];

      if (success && data != null) {
        return Right(
          AttendanceSessionModel.fromJson(
            (data as Map).cast<String, dynamic>(),
          ),
        );
      } else {
        return Left(
          ApiErrors(
            errorMessage:
                response['messages']?['Error'] ?? 'Failed to start session',
          ),
        );
      }
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, String>> submitAttendance({
    required String classOid,
    required String date,
    required List<Map<String, dynamic>> attendances,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/Attendance',
        data: {'classOid': classOid, 'date': date, 'attendances': attendances},
      );

      final success = response['success'] as bool? ?? false;
      if (success) {
        return Right(
          response['messages']?['EN']?.toString() ??
              'Attendance record created successfully',
        );
      } else {
        return Left(
          ApiErrors(
            errorMessage:
                response['messages']?['EN']?.toString() ??
                'Failed to submit attendance',
          ),
        );
      }
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }
}
