import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';
import 'parent_payments_state.dart';

class ParentPaymentsCubit extends Cubit<ParentPaymentsState> {
  final ParentDashboardRepo parentDashboardRepo;

  ParentPaymentsCubit(this.parentDashboardRepo) : super(ParentPaymentsInitial());

  Future<void> fetchPaymentSummary() async {
    emit(ParentPaymentsLoading());
    final summaryResult = await parentDashboardRepo.getPaymentSummary();
    final historyResult = await parentDashboardRepo.getPaymentHistory();

    summaryResult.fold(
      (error) => emit(ParentPaymentsFailure(error)),
      (summary) {
        historyResult.fold(
          (error) => emit(ParentPaymentsFailure(error)),
          (historyResponse) => emit(ParentPaymentsSuccess(summary, historyResponse.items)),
        );
      },
    );
  }
}
