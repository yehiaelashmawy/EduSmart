import 'package:dartz/dartz.dart';
import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/features/teacher/data/models/exam_submission_model.dart';

class ExamGradingRepo {
  final ApiService _apiService;
  ExamGradingRepo(this._apiService);

  // GET /api/Exams/{examId}/submissions
  Future<Either<ApiErrors, ExamSubmissionsResponse>> getExamSubmissions(
    String examId,
  ) async {
    try {
      final response = await _apiService.get('/api/Exams/$examId/submissions');
      if (response != null && response['success'] == true) {
        return Right(ExamSubmissionsResponse.fromJson(response));
      }
      return Left(ApiErrors(errorMessage: 'Failed to fetch submissions'));
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  // POST /api/Exams/{examId}/results
  Future<Either<ApiErrors, String>> gradeStudent({
    required String examId,
    required String studentId,
    required int score,
    required String remarks,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/Exams/$examId/results',
        data: {
          'examOid': examId,
          'studentOid': studentId,
          'score': score,
          'remarks': remarks,
        },
      );
      if (response != null && response['success'] == true) {
        return Right(response['data']?.toString() ?? 'Grade submitted');
      }
      return Left(ApiErrors(errorMessage: 'Failed to submit grade'));
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }
}
