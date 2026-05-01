import 'package:dartz/dartz.dart';
import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/features/student/data/models/student_exam_model.dart';

class StudentExamsRepo {
  final ApiService _apiService;

  StudentExamsRepo(this._apiService);

  Future<Either<ApiErrors, List<StudentExamModel>>> fetchExams() async {
    try {
      final response = await _apiService.get('/api/student/exams');
      final examsResponse = StudentExamsResponse.fromJson(response);
      return Right(examsResponse.exams);
    } catch (e) {
      if (e is ApiErrors) {
        return Left(e);
      }
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }
}
