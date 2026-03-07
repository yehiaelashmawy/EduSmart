import 'package:flutter/material.dart';
import 'package:school_system/core/helper/on_generate_route.dart';
import 'package:school_system/features/splash/presentation/views/splash_view.dart';

void main() {
  runApp(const SchoolSystemApp());
}

class SchoolSystemApp extends StatelessWidget {
  const SchoolSystemApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: onGenerateRoute,
      initialRoute: SplashView.routeName,
    );
  }
}
