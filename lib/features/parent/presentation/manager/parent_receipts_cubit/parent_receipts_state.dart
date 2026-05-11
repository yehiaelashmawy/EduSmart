import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/features/parent/data/models/receipt_model.dart';

abstract class ParentReceiptsState {}

class ParentReceiptsInitial extends ParentReceiptsState {}

class ParentReceiptsLoading extends ParentReceiptsState {}

class ParentReceiptsSuccess extends ParentReceiptsState {
  final ReceiptListResponseModel response;
  ParentReceiptsSuccess(this.response);
}

class ParentReceiptsFailure extends ParentReceiptsState {
  final ApiErrors error;
  ParentReceiptsFailure(this.error);
}
