import 'package:flutter/material.dart';
import 'package:school_system/features/Auth/presentation/views/auth_view.dart';
import 'package:school_system/features/Auth/presentation/views/forgot_password_view.dart';
import 'package:school_system/features/Auth/presentation/views/login_view.dart';
import 'package:school_system/features/Auth/presentation/views/resret_password_view.dart';
import 'package:school_system/features/Auth/presentation/views/verification_view.dart';
import 'package:school_system/features/on_broding/presentation/views/on_bording_view.dart';
import 'package:school_system/features/splash/presentation/views/splash_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(builder: (context) => const SplashView());
    case OnBordingView.routeName:
      return MaterialPageRoute(builder: (context) => const OnBordingView());
    case AuthView.routeName:
      return MaterialPageRoute(builder: (context) => const AuthView());
    case ResetPasswordView.routeName:
      return MaterialPageRoute(builder: (context) => const ResetPasswordView());
    case LoginView.routeName:
      return MaterialPageRoute(builder: (context) => const LoginView());
    case ForgotPasswordView.routeName:
      return MaterialPageRoute(
        builder: (context) => const ForgotPasswordView(),
      );
    case VerificationView.routeName:
      return MaterialPageRoute(builder: (context) => const VerificationView());
    default:
      return MaterialPageRoute(builder: (context) => const SplashView());
  }
}
