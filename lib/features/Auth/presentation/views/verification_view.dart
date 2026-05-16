import 'package:flutter/material.dart';
import 'package:school_system/features/Auth/presentation/views/widgets/verification_view_body.dart';

class VerificationViewArgs {
  final String email;

  VerificationViewArgs({required this.email});
}

class VerificationView extends StatelessWidget {
  final String? email;
  const VerificationView({super.key, this.email});
  static const routeName = 'verificationView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: VerificationViewBody(email: email ?? ''));
  }
}
