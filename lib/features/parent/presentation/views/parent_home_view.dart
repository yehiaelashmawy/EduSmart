import 'package:flutter/material.dart';

class ParentHomeView extends StatelessWidget {
  const ParentHomeView({super.key});
  static const String routeName = 'parent_home_view';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Parent Home View')));
  }
}
