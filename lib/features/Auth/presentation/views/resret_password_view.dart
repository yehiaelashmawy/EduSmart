import 'package:flutter/material.dart';
import 'package:school_system/features/Auth/presentation/views/widgets/reset_password_view_body.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});
  static const String routeName = 'ResetPasswordView';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: ResetPasswordViewBody());
  }
}
