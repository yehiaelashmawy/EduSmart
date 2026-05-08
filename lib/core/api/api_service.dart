import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:school_system/core/api/api_exceptions.dart';
import 'package:school_system/core/api/dio_client.dart';

class ApiService {
  final DioClient _dioClient = DioClient();

  // GET
  Future<dynamic> get(String endPoint) async {
    try {
      final response = await _dioClient.dio.get(
        endPoint,
        options: Options(responseType: ResponseType.bytes),
      );
      return jsonDecode(utf8.decode(response.data));
    } catch (e) {
      throw ApiExceptions.handleException(e as DioException);
    }
  }

  // POST (JSON)
  Future<dynamic> post(String endPoint, {dynamic data}) async {
    try {
      final response = await _dioClient.dio.post(
        endPoint, 
        data: data,
        options: Options(responseType: ResponseType.bytes),
      );
      return jsonDecode(utf8.decode(response.data));
    } catch (e) {
      throw ApiExceptions.handleException(e as DioException);
    }
  }

  // PUT
  Future<dynamic> put(String endPoint, {dynamic data}) async {
    try {
      final response = await _dioClient.dio.put(
        endPoint, 
        data: data,
        options: Options(responseType: ResponseType.bytes),
      );
      return jsonDecode(utf8.decode(response.data));
    } catch (e) {
      throw ApiExceptions.handleException(e as DioException);
    }
  }

  // DELETE
  Future<dynamic> delete(String endPoint) async {
    try {
      final response = await _dioClient.dio.delete(
        endPoint,
        options: Options(responseType: ResponseType.bytes),
      );
      return jsonDecode(utf8.decode(response.data));
    } catch (e) {
      throw ApiExceptions.handleException(e as DioException);
    }
  }

  // 🔥 Single file upload — POST /api/Files/upload/lessons/{id}
  Future<dynamic> postMultipart(
    String endPoint, {
    required String filePath,
    required String fileName,
  }) async {
    try {
      final formData = FormData.fromMap({
        'File': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await _dioClient.dio.post(
        endPoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return response.data;
    } catch (e) {
      if (e is DioException) throw ApiExceptions.handleException(e);
      rethrow;
    }
  }

  // 🔥 Single file upload from bytes (Web)
  Future<dynamic> postMultipartBytes(
    String endPoint, {
    required List<int> bytes,
    required String fileName,
  }) async {
    try {
      final formData = FormData.fromMap({
        'File': MultipartFile.fromBytes(bytes, filename: fileName),
      });

      final response = await _dioClient.dio.post(
        endPoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return response.data;
    } catch (e) {
      if (e is DioException) throw ApiExceptions.handleException(e);
      rethrow;
    }
  }

  // 🔥 Multiple files upload — POST /api/Files/upload-multiple/lessons/{id}
  Future<dynamic> postMultipartMultiple(
    String endPoint, {
    required List<MapEntry<String, MultipartFile>> files,
  }) async {
    try {
      final formData = FormData();

      // ✅ تأكد إن كل الملفات باسم "Files"
      formData.files.addAll(files);

      final response = await _dioClient.dio.post(
        endPoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return response.data;
    } catch (e) {
      if (e is DioException) throw ApiExceptions.handleException(e);
      rethrow;
    }
  }
}
