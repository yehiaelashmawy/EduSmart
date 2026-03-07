import 'package:flutter/material.dart';
import 'package:school_system/core/widgets/custom_app_bar.dart';

class ForgotPasswordViewBody extends StatelessWidget {
  const ForgotPasswordViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(children: [CustomAppBar(title: 'Forgot Password')]),
      ),
    );
  }
}
