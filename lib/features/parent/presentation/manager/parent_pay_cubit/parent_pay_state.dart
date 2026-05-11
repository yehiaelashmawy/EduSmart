import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/features/parent/data/models/payment_response_model.dart';

abstract class ParentPayState {}

class ParentPayInitial extends ParentPayState {}

class ParentPayLoading extends ParentPayState {}

class ParentPaySuccess extends ParentPayState {
  final PaymentResponseModel response;
  ParentPaySuccess(this.response);
}

class ParentPayFailure extends ParentPayState {
  final ApiErrors error;
  ParentPayFailure(this.error);
}
