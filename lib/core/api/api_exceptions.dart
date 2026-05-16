import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:school_system/core/api/api_errors.dart';

class ApiExceptions {
  static ApiErrors handleException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        return ApiErrors(errorMessage: 'Request cancelled');
      case DioExceptionType.connectionTimeout:
        return ApiErrors(errorMessage: 'Connection timeout');
      case DioExceptionType.receiveTimeout:
        return ApiErrors(errorMessage: 'Receive timeout');
      case DioExceptionType.sendTimeout:
        return ApiErrors(errorMessage: 'Send timeout');
      case DioExceptionType.badCertificate:
        return ApiErrors(errorMessage: 'Bad certificate');
      case DioExceptionType.badResponse:
        final rawData = e.response?.data;
        String extractedMsg = 'Request failed';

        try {
          // Convert bytes → String → Map if needed
          Map? responseMap;

          if (rawData is Map) {
            responseMap = rawData;
          } else if (rawData is List) {
            final decoded = jsonDecode(utf8.decode(rawData as List<int>));
            if (decoded is Map) {
              responseMap = decoded;
            }
          } else if (rawData is String) {
            final decoded = jsonDecode(rawData);
            if (decoded is Map) {
              responseMap = decoded;
            }
          }

          if (responseMap != null) {
            // Priority 1: errors[] array
            final errors = responseMap['errors'];
            if (errors is List && errors.isNotEmpty) {
              extractedMsg = errors.first.toString();
            }
            // Priority 2: messages.EN
            else if (responseMap['messages'] is Map) {
              final messages = responseMap['messages'] as Map;
              extractedMsg = messages['EN']?.toString()
                  ?? messages['Error']?.toString()
                  ?? messages['AR']?.toString()
                  ?? extractedMsg;
            }
          }
        } catch (_) {
          // keep fallback 'Request failed'
        }

        return ApiErrors(errorMessage: extractedMsg);
      case DioExceptionType.connectionError:
        return ApiErrors(errorMessage: 'Connection error');
      case DioExceptionType.unknown:
        return ApiErrors(errorMessage: 'Unknown error');

      // ignore: unreachable_switch_default
      default:
        return ApiErrors(errorMessage: 'Unknown error');
    }
  }
}
