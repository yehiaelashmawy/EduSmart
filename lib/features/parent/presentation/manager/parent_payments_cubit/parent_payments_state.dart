import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/features/parent/data/models/payment_summary_model.dart';

abstract class ParentPaymentsState {}

class ParentPaymentsInitial extends ParentPaymentsState {}

class ParentPaymentsLoading extends ParentPaymentsState {}

class ParentPaymentsSuccess extends ParentPaymentsState {
  final PaymentSummaryModel summary;
  ParentPaymentsSuccess(this.summary);
}

class ParentPaymentsFailure extends ParentPaymentsState {
  final ApiErrors error;
  ParentPaymentsFailure(this.error);
}
