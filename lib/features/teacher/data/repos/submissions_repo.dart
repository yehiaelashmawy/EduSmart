import 'package:dartz/dartz.dart';
import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/features/teacher/data/models/submission_model.dart';

class SubmissionsRepo {
  final ApiService apiService;

  SubmissionsRepo(this.apiService);

  Future<Either<ApiErrors, List<SubmissionModel>>> getSubmissions(
    String homeworkId,
  ) async {
    try {
      final response = await apiService.get(
        '/api/Homeworks/$homeworkId/submissions',
      );

      if (response != null && response['success'] == true) {
        final dataRaw = response['data'];
        if (dataRaw is List) {
          final submissions = dataRaw
              .whereType<Map>()
              .map(
                (e) => SubmissionModel.fromJson(e.cast<String, dynamic>()),
              )
              .toList();
          return Right(submissions);
        }
        return const Right([]);
      }

      return Left(ApiErrors(errorMessage: 'Failed to fetch submissions'));
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, String>> gradeSubmission({
    required String homeworkId,
    required String submissionId,
    required double grade,
    String? feedback,
  }) async {
    try {
      final response = await apiService.post(
        '/api/Homeworks/$homeworkId/submissions/$submissionId/grade',
        data: {
          'grade': grade,
          if (feedback != null && feedback.isNotEmpty) 'feedback': feedback,
        },
      );

      if (response != null && response['success'] == true) {
        final msg =
            response['messages']?['EN']?.toString() ?? 'Graded successfully';
        return Right(msg);
      }

      return Left(ApiErrors(errorMessage: 'Failed to submit grade'));
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }
}
