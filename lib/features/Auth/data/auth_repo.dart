import 'package:dio/dio.dart';
import 'package:school_system/features/Auth/data/user_model.dart';

import '../../../core/api/api_exceptions.dart';
import '../../../core/api/api_service.dart';

class AuthRepo {
  //login
  Future<UserModel> login(String email, String password, int role) async {
    try {
      final response = await ApiService().post(
        '/api/Auth/login',
        data: {'email': email, 'password': password, 'role': role},
      );

      // Since ApiService().post returns response.data directly, it is already a decoded map.
      if (response['success'] == true && response['data'] != null) {
        return UserModel.fromJson(response['data']);
      } else {
        String errMsg = 'Invalid email or password';

        if (response is Map) {
          // 1️⃣ errors (List)
          final errors = response['errors'];
          if (errors is List && errors.isNotEmpty) {
            errMsg = errors.first.toString();
          }
          // 2️⃣ messages (Map)
          else if (response['messages'] is Map) {
            final msgs = response['messages'] as Map;

            if (msgs['EN'] != null) {
              errMsg = msgs['EN'].toString();
            } else if (msgs['error'] != null) {
              errMsg = msgs['error'].toString();
            } else if (msgs.isNotEmpty) {
              errMsg = msgs.values.first.toString();
            }
          }
          // 3️⃣ message (String)
          else if (response['message'] != null) {
            errMsg = response['message'].toString();
          }
        }

        throw Exception(errMsg);
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    } catch (e) {
      rethrow;
    }
  }

  // Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      final response = await ApiService().post(
        '/api/Auth/forgot-password',
        data: {'email': email},
      );

      if (response['success'] != true) {
        String errMsg = 'Failed to send reset email';
        
        if (response is Map) {
          final errors = response['errors'];
          if (errors is List && errors.isNotEmpty) {
            errMsg = errors.first.toString();
          } else if (response['messages'] is Map) {
            final msgs = response['messages'] as Map;
            if (msgs['EN'] != null) {
              errMsg = msgs['EN'].toString();
            } else if (msgs['error'] != null) {
              errMsg = msgs['error'].toString();
            } else if (msgs.isNotEmpty) {
              errMsg = msgs.values.first.toString();
            }
          } else if (response['message'] != null) {
            errMsg = response['message'].toString();
          }
        }
        
        throw Exception(errMsg);
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    } catch (e) {
      rethrow;
    }
  }

  // Reset Password
  Future<void> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await ApiService().post(
        '/api/Auth/verify-otp-reset',
        data: {
          'email': email,
          'otpCode': otpCode,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );

      if (response['success'] != true) {
        String errMsg = 'Failed to reset password';
        
        if (response is Map) {
          final errors = response['errors'];
          if (errors is List && errors.isNotEmpty) {
            errMsg = errors.first.toString();
          } else if (response['messages'] is Map) {
            final msgs = response['messages'] as Map;
            if (msgs['EN'] != null) {
              errMsg = msgs['EN'].toString();
            } else if (msgs['error'] != null) {
              errMsg = msgs['error'].toString();
            } else if (msgs.isNotEmpty) {
              errMsg = msgs.values.first.toString();
            }
          } else if (response['message'] != null) {
            errMsg = response['message'].toString();
          }
        }
        
        throw Exception(errMsg);
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    } catch (e) {
      rethrow;
    }
  }
}
