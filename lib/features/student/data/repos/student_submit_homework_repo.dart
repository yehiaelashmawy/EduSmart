import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/core/api/api_service.dart';

class StudentSubmitHomeworkRepo {
  final ApiService _apiService;

  StudentSubmitHomeworkRepo(this._apiService);

  Future<Either<ApiErrors, String>> uploadAttachment({
    required String homeworkId,
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
        '/api/student/homework/$homeworkId/upload-attachment',
        data: formData,
      );

      if (response['success'] == true) {
        return Right(response['data']['attachmentUrl']);
      } else {
        return Left(
          ApiErrors(errorMessage: response['message'] ?? 'Upload failed'),
        );
      }
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, bool>> submitHomework({
    required String homeworkId,
    required String submissionText,
    required String attachmentUrl,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/student/homework/$homeworkId/submit',
        data: {
          'submissionText': submissionText,
          'attachmentUrl': attachmentUrl,
        },
      );

      if (response['success'] == true) {
        return const Right(true);
      } else {
        return Left(
          ApiErrors(errorMessage: response['message'] ?? 'Submission failed'),
        );
      }
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }
}
