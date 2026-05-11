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
      // Fetch submissions and homework list in parallel
      final results = await Future.wait([
        apiService.get('/api/Homeworks/$homeworkId/submissions'),
        apiService.get('/api/Homeworks/teacher'),
      ]);

      final subResponse = results[0];
      final hwResponse = results[1];

      if (subResponse != null && subResponse['success'] == true) {
        // Extract totalMarks from the teacher homework list
        double? totalMarks;
        if (hwResponse != null && hwResponse['success'] == true) {
          final hwList = hwResponse['data'];
          if (hwList is List) {
            final match = hwList.whereType<Map>().firstWhere(
              (hw) =>
                  (hw['id'] ?? hw['oid'] ?? '').toString() == homeworkId,
              orElse: () => {},
            );
            if (match.isNotEmpty) {
              totalMarks = (match['totalMarks'] as num?)?.toDouble();
            }
          }
        }

        final dataRaw = subResponse['data'];
        if (dataRaw is List) {
          final submissions = dataRaw
              .whereType<Map>()
              .map((e) {
                final model = SubmissionModel.fromJson(e.cast<String, dynamic>());
                // Inject totalMarks from homework list if not present in submission
                if (model.totalMarks == null && totalMarks != null) {
                  return SubmissionModel(
                    id: model.id,
                    studentName: model.studentName,
                    studentEmail: model.studentEmail,
                    content: model.content,
                    attachmentUrl: model.attachmentUrl,
                    submittedAt: model.submittedAt,
                    grade: model.grade,
                    totalMarks: totalMarks,
                    feedback: model.feedback,
                    status: model.status,
                    isLate: model.isLate,
                  );
                }
                return model;
              })
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
        '/api/Homeworks/$homeworkId/grade',
        data: {
          'submissionId': submissionId,
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

  Future<Either<ApiErrors, List<SubmissionModel>>> getExamSubmissions(
    String examId,
  ) async {
    try {
      final response = await apiService.get(
        '/api/Exams/$examId/submissions',
      );

      if (response != null && response['success'] == true) {
        final dataRaw = response['data']?['submissions'];
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

      return Left(ApiErrors(errorMessage: 'Failed to fetch exam submissions'));
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, String>> gradeExamSubmission({
    required String examId,
    required String submissionId,
    required double grade,
    String? feedback,
  }) async {
    try {
      final response = await apiService.post(
        '/api/Exams/$examId/grade',
        data: {
          'submissionId': submissionId,
          'grade': grade,
          if (feedback != null && feedback.isNotEmpty) 'feedback': feedback,
        },
      );

      if (response != null && response['success'] == true) {
        final msg =
            response['messages']?['EN']?.toString() ?? 'Graded successfully';
        return Right(msg);
      }

      return Left(ApiErrors(errorMessage: 'Failed to submit exam grade'));
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }
}
