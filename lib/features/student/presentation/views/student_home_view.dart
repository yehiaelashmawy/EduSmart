import 'package:flutter/material.dart';

class StudentHomeView extends StatelessWidget {
  const StudentHomeView({super.key});
  static const String routeName = 'student_home_view';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Student Home View')));
  }
}
