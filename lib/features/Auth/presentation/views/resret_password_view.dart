import 'package:flutter/material.dart';
import 'package:school_system/features/Auth/presentation/views/widgets/reset_password_view_body.dart';

class ResetPasswordViewArgs {
  final String email;
  final String otpCode;

  ResetPasswordViewArgs({required this.email, required this.otpCode});
}

class ResetPasswordView extends StatelessWidget {
  final String? email;
  final String? otpCode;

  const ResetPasswordView({super.key, this.email, this.otpCode});
  static const String routeName = 'ResetPasswordView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResetPasswordViewBody(
        email: email ?? '',
        otpCode: otpCode ?? '',
      ),
    );
  }
}
