import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';
import 'parent_receipts_state.dart';

class ParentReceiptsCubit extends Cubit<ParentReceiptsState> {
  final ParentDashboardRepo parentDashboardRepo;

  ParentReceiptsCubit(this.parentDashboardRepo) : super(ParentReceiptsInitial());

  Future<void> fetchReceipts() async {
    emit(ParentReceiptsLoading());
    final result = await parentDashboardRepo.getReceipts();
    result.fold(
      (error) => emit(ParentReceiptsFailure(error)),
      (response) => emit(ParentReceiptsSuccess(response)),
    );
  }
}
