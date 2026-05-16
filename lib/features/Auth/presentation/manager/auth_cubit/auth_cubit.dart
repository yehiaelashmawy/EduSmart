import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/Auth/data/auth_repo.dart';
import 'package:school_system/features/Auth/presentation/manager/auth_cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;

  AuthCubit(this.authRepo) : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
    required String roleName,
  }) async {
    emit(AuthLoading());

    // Map the string role to integer API role
    int roleId = 3;
    if (roleName == 'teacher') {
      roleId = 2;
    } else if (roleName == 'student') {
      roleId = 3;
    } else if (roleName == 'parent') {
      roleId = 4;
    }

    try {
      final user = await authRepo.login(email, password, roleId);
      emit(AuthSuccess(user: user));
    } catch (e) {
      String errStr = e.toString();
      if (errStr.startsWith('Exception: ')) {
        errStr = errStr.substring(11);
      }
      emit(AuthFailure(errorMessage: errStr));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    try {
      await authRepo.forgotPassword(email);
      emit(ForgotPasswordSuccess());
    } catch (e) {
      String errStr = e.toString();
      if (errStr.startsWith('Exception: ')) {
        errStr = errStr.substring(11);
      }
      emit(AuthFailure(errorMessage: errStr));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());
    try {
      await authRepo.resetPassword(
        email: email,
        otpCode: otpCode,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      emit(ResetPasswordSuccess());
    } catch (e) {
      String errStr = e.toString();
      if (errStr.startsWith('Exception: ')) {
        errStr = errStr.substring(11);
      }
      emit(AuthFailure(errorMessage: errStr));
    }
  }
}
