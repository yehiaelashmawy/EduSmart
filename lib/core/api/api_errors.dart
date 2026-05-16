import 'package:dio/dio.dart';

class ApiErrors {
  final String errorMessage;

  ApiErrors({required this.errorMessage});
  @override
  String toString() {
    return errorMessage;
  }

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
        final responseData = e.response?.data;
        String extractedMsg = 'Request failed';

        if (responseData is Map<String, dynamic>) {
          final errors = responseData['errors'];
          if (errors is List && errors.isNotEmpty) {
            extractedMsg = errors.first.toString();
          } else if (responseData['messages'] is Map) {
            final msgs = responseData['messages'] as Map;
            if (msgs['EN'] != null) {
              extractedMsg = msgs['EN'].toString();
            } else if (msgs['error'] != null) {
              extractedMsg = msgs['error'].toString();
            } else if (msgs.isNotEmpty) {
              extractedMsg = msgs.values.first.toString();
            }
          } else if (responseData['message'] != null) {
            extractedMsg = responseData['message'].toString();
          }
        } else if (responseData is String && responseData.trim().isNotEmpty) {
          extractedMsg = responseData;
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
