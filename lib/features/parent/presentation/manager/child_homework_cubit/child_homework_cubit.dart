import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';
import 'child_homework_state.dart';

class ChildHomeworkCubit extends Cubit<ChildHomeworkState> {
  final ParentDashboardRepo _repo;
  final String childId;

  ChildHomeworkCubit(this._repo, {required this.childId})
      : super(ChildHomeworkInitial());

  Future<void> fetchHomework() async {
    emit(ChildHomeworkLoading());
    final result = await _repo.getChildrenHomework();
    result.fold(
      (error) => emit(ChildHomeworkFailure(error)),
      (dataList) {
        final childHomework = dataList.where(
          (h) => h.studentOid == childId,
        ).toList();
        emit(ChildHomeworkSuccess(childHomework));
      },
    );
  }
}
