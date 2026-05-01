import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/core/api/api_service.dart';

class StudentSubmitExamRepo {
  final ApiService _apiService;

  StudentSubmitExamRepo(this._apiService);

  Future<Either<ApiErrors, Map<String, dynamic>>> uploadSolution({
    required String examId,
    required File file,
  }) async {
    try {
      final formData = FormData.fromMap({
        'File': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await _apiService.post(
        '/api/student/exams/$examId/upload-solution',
        data: formData,
      );

      if (response['success'] == true) {
        return Right(response['data']);
      } else {
        return Left(ApiErrors(errorMessage: 'Upload failed'));
      }
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, bool>> submitExam({
    required String examId,
    required String answerText,
    required String attachmentUrl,
    required String fileName,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/student/exams/$examId/submit',
        data: {
          'answerText': answerText,
          'attachmentUrl': attachmentUrl,
          'fileName': fileName,
        },
      );

      if (response['success'] == true) {
        return const Right(true);
      } else {
        return Left(ApiErrors(errorMessage: 'Submission failed'));
      }
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }
}
