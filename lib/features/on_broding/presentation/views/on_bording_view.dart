import 'package:flutter/material.dart';
import 'package:school_system/features/on_broding/presentation/views/widgets/on_bording_view_body.dart';

class OnBordingView extends StatelessWidget {
  const OnBordingView({super.key});
  static const routeName = 'onBordingView';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: OnBordingViewBody());
  }
}
