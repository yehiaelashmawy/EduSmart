import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/parent/data/models/payment_request_model.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';
import 'parent_pay_state.dart';

class ParentPayCubit extends Cubit<ParentPayState> {
  final ParentDashboardRepo parentDashboardRepo;

  ParentPayCubit(this.parentDashboardRepo) : super(ParentPayInitial());

  Future<void> processPayment(PaymentRequestModel request) async {
    emit(ParentPayLoading());
    final result = await parentDashboardRepo.pay(request);

    result.fold(
      (error) => emit(ParentPayFailure(error)),
      (response) => emit(ParentPaySuccess(response)),
    );
  }

  Future<void> processFawaterkPayment(PaymentRequestModel request) async {
    emit(ParentPayLoading());
    final result = await parentDashboardRepo.payFawry(request);

    result.fold(
      (error) => emit(ParentPayFailure(error)),
      (response) => emit(ParentFawaterkPaySuccess(response)),
    );
  }
}
