import 'package:flutter/material.dart';
import 'package:school_system/features/Auth/presentation/views/auth_view.dart';
import 'package:school_system/features/Auth/presentation/views/forgot_password_view.dart';
import 'package:school_system/features/Auth/presentation/views/login_view.dart';
import 'package:school_system/features/Auth/presentation/views/resret_password_view.dart';
import 'package:school_system/features/Auth/presentation/views/scusse_view.dart';
import 'package:school_system/features/Auth/presentation/views/verification_view.dart';
import 'package:school_system/features/on_broding/presentation/views/on_bording_view.dart';
import 'package:school_system/features/parent/presentation/views/parent_home_view.dart';
import 'package:school_system/features/splash/presentation/views/splash_view.dart';
import 'package:school_system/features/student/presentation/views/student_home_view.dart';
import 'package:school_system/features/teacher/presentation/views/add_homework_view.dart';
import 'package:school_system/features/teacher/presentation/views/add_new_lesson_view.dart';
import 'package:school_system/features/teacher/presentation/views/lesson_details_view.dart';
import 'package:school_system/features/teacher/presentation/views/student_list.dart';
import 'package:school_system/features/teacher/presentation/views/teacher_classes_view.dart';
import 'package:school_system/features/teacher/presentation/views/teacher_home_view.dart';
import 'package:school_system/features/teacher/presentation/views/teacher_profile_view.dart';
import 'package:school_system/features/teacher/presentation/views/personal_information_view.dart';
import 'package:school_system/features/teacher/presentation/views/change_password_view.dart';
import 'package:school_system/features/teacher/presentation/views/settings_view.dart';
import 'package:school_system/features/teacher/presentation/views/grade_submission_view.dart';

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
      return MaterialPageRoute(
        builder: (context) => const LoginView(),
        settings: settings,
      );
    case ForgotPasswordView.routeName:
      return MaterialPageRoute(
        builder: (context) => const ForgotPasswordView(),
      );
    case TeacherHomeView.routeName:
      return MaterialPageRoute(builder: (context) => const TeacherHomeView());
    case VerificationView.routeName:
      return MaterialPageRoute(builder: (context) => const VerificationView());
    case StudentHomeView.routeName:
      return MaterialPageRoute(builder: (context) => const StudentHomeView());
    case ParentHomeView.routeName:
      return MaterialPageRoute(builder: (context) => const ParentHomeView());

    case StudentList.routeName:
      return MaterialPageRoute(builder: (context) => const StudentList());
    case LessonDetailsView.routeName:
      return MaterialPageRoute(builder: (context) => const LessonDetailsView());
    case AddNewLessonView.routeName:
      return MaterialPageRoute(builder: (context) => const AddNewLessonView());
    case TeacherClassesView.routeName:
      return MaterialPageRoute(
        builder: (context) => const TeacherClassesView(),
      );
    case ScusseView.routeName:
      return MaterialPageRoute(builder: (context) => const ScusseView());
    case AddHomeworkView.routeName:
      return MaterialPageRoute(builder: (context) => const AddHomeworkView());

    case TeacherProfileView.routeName:
      return MaterialPageRoute(
        builder: (context) => const TeacherProfileView(),
      );

    case PersonalInformationView.routeName:
      return MaterialPageRoute(
        builder: (context) => const PersonalInformationView(),
      );
    case ChangePasswordView.routeName:
      return MaterialPageRoute(
        builder: (context) => const ChangePasswordView(),
      );
    case SettingsView.routeName:
      return MaterialPageRoute(
        builder: (context) => const SettingsView(),
      );
    case GradeSubmissionView.routeName:
      return MaterialPageRoute(builder: (context) => const GradeSubmissionView());
    default:
      return MaterialPageRoute(builder: (context) => const SplashView());
  }
}
