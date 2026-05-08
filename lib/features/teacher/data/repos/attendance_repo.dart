import 'package:dartz/dartz.dart';
import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/features/teacher/data/models/attendance_session_model.dart';
import 'package:school_system/features/teacher/data/models/class_attendance_stats_model.dart';
import 'package:school_system/features/teacher/data/models/session_tracking_model.dart';

class AttendanceRepo {
  final ApiService _apiService;

  AttendanceRepo(this._apiService);

  Future<Either<ApiErrors, AttendanceSessionModel>> startSession({
    required String classOid,
    required int method,
    String? lessonOid,
    int correctNumber = 0,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/Attendance/start-session',
        data: {
          'classOid': classOid, 
          'method': method, 
          'lessonOid': lessonOid,
          'correctNumber': correctNumber,
        },
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

  Future<Either<ApiErrors, bool>> submitSession({
    required String sessionId,
    required int selectedNumber,
    required List<Map<String, dynamic>> attendances,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/Attendance/submit-session',
        data: {
          'sessionId': sessionId,
          'selectedNumber': selectedNumber,
          'attendances': attendances,
        },
      );

      final success = response['success'] as bool? ?? false;
      if (success) {
        return const Right(true);
      } else {
        return Left(
          ApiErrors(
            errorMessage:
                response['messages']?['Error']?.toString() ??
                response['messages']?['EN']?.toString() ??
                'Failed to submit session',
          ),
        );
      }
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, ClassAttendanceStatsModel>> getClassStats(
    String classOid,
  ) async {
    try {
      final response = await _apiService.get(
        '/api/Attendance/class-stats/$classOid',
      );

      final success = response['success'] as bool? ?? false;
      final data = response['data'];

      if (success && data != null) {
        return Right(
          ClassAttendanceStatsModel.fromJson(
            (data as Map).cast<String, dynamic>(),
          ),
        );
      } else {
        return Left(
          ApiErrors(
            errorMessage:
                response['messages']?['EN']?.toString() ??
                'Failed to fetch class statistics',
          ),
        );
      }
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, AttendanceSessionModel>> getActiveSession() async {
    try {
      final response = await _apiService.get('/api/Attendance/active-session');
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
                response['messages']?['Error']?.toString() ??
                'No active session',
          ),
        );
      }
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, SessionTrackingModel>> getSessionDetail(
    String sessionId,
  ) async {
    try {
      final response = await _apiService.get(
        '/api/Attendance/session/$sessionId',
      );

      final success = response['success'] as bool? ?? false;
      final data = response['data'];

      if (success && data != null) {
        return Right(
          SessionTrackingModel.fromJson(
            (data as Map).cast<String, dynamic>(),
          ),
        );
      } else {
        return Left(
          ApiErrors(
            errorMessage:
                response['messages']?['EN']?.toString() ??
                'Failed to fetch session detail',
          ),
        );
      }
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, List<dynamic>>> getSessions(
    String classOid,
  ) async {
    try {
      final response = await _apiService.get(
        '/api/Attendance/sessions?classOid=$classOid',
      );

      final success = response['success'] as bool? ?? false;
      final data = response['data'];

      if (success && data != null) {
        final sessions = (data as Map)['sessions'] as List? ?? [];
        return Right(sessions);
      } else {
        return Left(
          ApiErrors(
            errorMessage:
                response['messages']?['EN']?.toString() ??
                'Failed to fetch sessions',
          ),
        );
      }
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }
}
