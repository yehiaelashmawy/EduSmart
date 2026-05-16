import 'package:flutter/foundation.dart';
import 'package:school_system/features/Auth/data/user_model.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;

  AuthSuccess({required this.user});
}

class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure({required this.errorMessage});
}

class ForgotPasswordSuccess extends AuthState {}

class ResetPasswordSuccess extends AuthState {}
