import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/core/utils/app_constants.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/features/parent/data/models/parent_dashboard_model.dart';
import 'package:school_system/features/parent/data/models/parent_attendance_model.dart';
import 'package:school_system/features/parent/data/models/parent_grades_model.dart';
import 'package:school_system/features/parent/data/models/parent_homework_model.dart';
import 'package:school_system/features/parent/data/models/parent_weekly_schedule_model.dart';
import 'package:school_system/features/parent/data/models/receipt_model.dart';
import 'package:school_system/features/parent/data/models/payment_history_model.dart';
import 'package:school_system/features/parent/data/models/payment_summary_model.dart';
import 'package:school_system/features/parent/data/models/payment_request_model.dart';
import 'package:school_system/features/parent/data/models/payment_response_model.dart';
import 'package:school_system/features/parent/data/models/fawaterk_payment_method_model.dart';
import 'package:school_system/features/parent/data/models/fawaterk_payment_response_model.dart';

class ParentDashboardRepo {
  final ApiService apiService;

  ParentDashboardRepo(this.apiService);

  Future<Either<ApiErrors, ReceiptListResponseModel>> getReceipts({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await apiService.get(
        '/api/parent/payments/receipts?page=$page&pageSize=$pageSize',
      );
      final dataJson = response['data'] ?? response;
      final data = ReceiptListResponseModel.fromJson(dataJson);
      return Right(data);
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, PaymentHistoryResponseModel>> getPaymentHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await apiService.get(
        '/api/parent/payments/history?page=$page&pageSize=$pageSize',
      );
      final dataJson = response['data'] ?? response;
      final data = PaymentHistoryResponseModel.fromJson(dataJson);
      return Right(data);
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, PaymentSummaryModel>> getPaymentSummary() async {
    try {
      final response = await apiService.get('/api/parent/payments/summary');
      // Use the root response if 'data' is null, as seen in the CURL provided
      final dataJson = response['data'] ?? response;
      final data = PaymentSummaryModel.fromJson(dataJson);
      return Right(data);
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, ParentDashboardModel>> getDashboard() async {
    try {
      final response = await apiService.get('/api/Parents/dashboard');
      final data = ParentDashboardModel.fromJson(response['data']);
      return Right(data);
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, List<ParentChildModel>>> getChildren() async {
    try {
      final response = await apiService.get('/api/Parents/my-children');
      final List childrenJson = response['data']['children'] ?? [];
      final children = childrenJson
          .map((e) => ParentChildModel.fromJson(e))
          .toList();
      return Right(children);
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, ChildrenAttendanceModel>>
  getChildrenAttendance() async {
    try {
      final response = await apiService.get('/api/Parents/Children-Attendance');
      final data = ChildrenAttendanceModel.fromJson(response['data']);
      return Right(data);
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, List<ParentGradesModel>>> getGrades() async {
    try {
      final response = await apiService.get('/api/Parents/grades');
      final List dataJson = response['data'] ?? [];
      final data = dataJson.map((e) => ParentGradesModel.fromJson(e)).toList();
      return Right(data);
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, List<ParentHomeworkModel>>>
  getChildrenHomework() async {
    try {
      final response = await apiService.get('/api/Parents/children-homework');
      final List dataJson = response['data'] ?? [];
      final data = dataJson
          .map((e) => ParentHomeworkModel.fromJson(e))
          .toList();
      return Right(data);
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, ParentWeeklyScheduleModel>> getChildWeeklySchedule(
    String childId,
  ) async {
    try {
      final response = await apiService.get('/api/Parents/$childId/schedule');
      final data = ParentWeeklyScheduleModel.fromJson(response['data']);
      return Right(data);
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, PaymentResponseModel>> pay(
    PaymentRequestModel request,
  ) async {
    try {
      final response = await apiService.post(
        '/api/parent/payments/pay',
        data: request.toJson(),
      );
      final dataJson = response['data'] ?? response;
      final data = PaymentResponseModel.fromJson(dataJson);
      return Right(data);
    } catch (e) {
      if (e is ApiErrors) return Left(e);
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, List<FawaterkPaymentMethodModel>>>
  getFawaterkPaymentMethods() async {
    try {
      final response = await Dio().get(
        'https://staging.fawaterk.com/api/v2/getPaymentmethods',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${AppConstants.fawaterkToken}',
            'Content-Type': 'application/json',
          },
        ),
      );
      final List dataJson = response.data['data'] ?? [];
      final data = dataJson
          .map((e) => FawaterkPaymentMethodModel.fromJson(e))
          .toList();
      return Right(data);
    } catch (e) {
      if (e is DioException) {
        return Left(ApiErrors(errorMessage: e.message ?? 'Unknown error'));
      }
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }

  Future<Either<ApiErrors, FawaterkPaymentResponseModel>> payFawry(
    PaymentRequestModel request,
  ) async {
    try {
      final paymentMethodId =
          int.tryParse(request.cardNumber) ??
          3; // Dynamically retrieve payment method id from the quick hack

      final response = await Dio().post(
        'https://staging.fawaterk.com/api/v2/invoiceInitPay',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${AppConstants.fawaterkToken}',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "payment_method_id": paymentMethodId, // Dynamic
          "cartTotal": request.amount.toString(),
          "currency": "EGP",
          "customer": {
            "first_name": request.cardholderName,
            "last_name": "Name",
            "email": request.email.isNotEmpty ? request.email : "test@test.com",
            "phone": request.phone.isNotEmpty ? request.phone : "01000000000",
            "address": "Egypt",
          },
          "redirectionUrls": {
            "successUrl": "https://schoolsystem.com/success",
            "failUrl": "https://schoolsystem.com/fail",
            "pendingUrl": "https://schoolsystem.com/pending",
          },
          "cartItems": [
            {
              "name": "School Fees",
              "price": request.amount.toString(),
              "quantity": "1",
            },
          ],
        },
      );
      final data = FawaterkPaymentResponseModel.fromJson(response.data);
      return Right(data);
    } catch (e) {
      if (e is DioException) {
        return Left(
          ApiErrors(
            errorMessage:
                e.response?.data?['message'] ?? e.message ?? 'Unknown error',
          ),
        );
      }
      return Left(ApiErrors(errorMessage: e.toString()));
    }
  }
}
