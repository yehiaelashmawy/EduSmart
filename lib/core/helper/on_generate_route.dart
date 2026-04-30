import 'package:flutter/material.dart';
import 'package:school_system/core/widgets/messages/messages_view.dart';
import 'package:school_system/core/widgets/messages/chat/chat_view.dart';
import 'package:school_system/core/widgets/notifications/notifications_view.dart';
import 'package:school_system/core/widgets/smart_tutor/smart_tutor_view.dart';
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
import 'package:school_system/features/student/presentation/views/weekly_schedule_view.dart';
import 'package:school_system/features/student/presentation/views/student_subject_details_view.dart';
import 'package:school_system/features/student/presentation/views/student_lesson_details_view.dart';
import 'package:school_system/features/student/presentation/views/student_assignment_details_view.dart';
import 'package:school_system/features/student/presentation/views/student_exam_details_view.dart';
import 'package:school_system/features/student/presentation/views/student_homework_view.dart';
import 'package:school_system/features/student/presentation/views/student_grades_view.dart';
import 'package:school_system/features/student/presentation/views/student_attendance_method_view.dart';
import 'package:school_system/features/student/presentation/views/student_scan_qr_view.dart';
import 'package:school_system/features/student/presentation/views/student_select_code_view.dart';
import 'package:school_system/features/student/presentation/views/student_attendance_success_view.dart';
import 'package:school_system/features/student/data/models/student_subject_model.dart';
import 'package:school_system/features/teacher/presentation/views/add_new_exam_view.dart';
import 'package:school_system/features/teacher/presentation/views/exam_details_view.dart';
import 'package:school_system/features/teacher/presentation/views/exam_results_view.dart';
import 'package:school_system/features/teacher/presentation/views/add_homework_view.dart';
import 'package:school_system/features/teacher/presentation/views/add_new_lesson_view.dart';
import 'package:school_system/features/teacher/presentation/views/lesson_details_view.dart';
import 'package:school_system/features/teacher/presentation/views/student_list.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/presentation/views/teacher_classes_view.dart';
import 'package:school_system/features/teacher/presentation/views/teacher_home_view.dart';
import 'package:school_system/features/teacher/presentation/views/personal_information_view.dart';
import 'package:school_system/features/teacher/presentation/views/change_password_view.dart';
import 'package:school_system/features/teacher/presentation/views/settings_view.dart';
import 'package:school_system/features/teacher/presentation/views/grade_submission_view.dart';
import 'package:school_system/features/teacher/presentation/views/take_attendance_view.dart';
import 'package:school_system/features/teacher/presentation/views/attendance_method_view.dart';
import 'package:school_system/features/teacher/presentation/views/manual_attendance_view.dart';
import 'package:school_system/features/teacher/presentation/views/generate_qr_code_view.dart';
import 'package:school_system/features/teacher/presentation/views/entry_code_view.dart';
import 'package:school_system/features/teacher/presentation/views/attendance_report_view.dart';
import 'package:school_system/features/teacher/presentation/views/teacher_weekly_schedule_view.dart';
import 'package:school_system/features/teacher/data/models/attendance_session_model.dart';

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
    case WeeklyScheduleView.routeName:
      return MaterialPageRoute(
        builder: (context) => const WeeklyScheduleView(),
      );
    case TeacherWeeklyScheduleView.routeName:
      return MaterialPageRoute(
        builder: (context) => const TeacherWeeklyScheduleView(),
      );
    case StudentSubjectDetailsView.routeName:
      final subject = settings.arguments as StudentSubjectModel;
      return MaterialPageRoute(
        builder: (context) => StudentSubjectDetailsView(subject: subject),
      );
    case StudentLessonDetailsView.routeName:
      final id = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => StudentLessonDetailsView(lessonId: id),
      );
    case StudentAssignmentDetailsView.routeName:
      final args = settings.arguments as StudentAssignmentDetailsArgs;
      return MaterialPageRoute(
        builder: (context) => StudentAssignmentDetailsView(
          homework: args.homework,
        ),
      );
    case StudentAttendanceMethodView.routeName:
      final subject = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => StudentAttendanceMethodView(subject: subject),
      );
    case StudentScanQrView.routeName:
      final subject = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => StudentScanQrView(subject: subject),
      );
    case StudentSelectCodeView.routeName:
      return MaterialPageRoute(
        builder: (context) => const StudentSelectCodeView(),
      );
    case StudentAttendanceSuccessView.routeName:
      return MaterialPageRoute(
        builder: (context) => const StudentAttendanceSuccessView(),
      );

    case StudentExamDetailsView.routeName:
      final args = settings.arguments as StudentExamDetailsArgs;
      return MaterialPageRoute(
        builder: (context) => StudentExamDetailsView(
          status: args.status,
          title: args.title,
          date: args.date,
          time: args.time,
          duration: args.duration,
          room: args.room,
          instructions: args.instructions,
        ),
      );
    case StudentHomeworkView.routeName:
      return MaterialPageRoute(
        builder: (context) => const StudentHomeworkView(),
      );
    case StudentGradesView.routeName:
      return MaterialPageRoute(builder: (context) => const StudentGradesView());
    case ParentHomeView.routeName:
      return MaterialPageRoute(builder: (context) => const ParentHomeView());
    case StudentList.routeName:
      final args = settings.arguments;
      if (args is TeacherClassModel) {
        return MaterialPageRoute(
          builder: (context) =>
              StudentList(className: args.name, teacherClass: args),
        );
      }
      final className = args as String? ?? 'Grade 10-A - Mathematics';
      return MaterialPageRoute(
        builder: (context) => StudentList(className: className),
      );
    case LessonDetailsView.routeName:
      final lessonId = settings.arguments as String?;
      return MaterialPageRoute(
        builder: (context) => LessonDetailsView(lessonId: lessonId),
      );
    case AddNewLessonView.routeName:
      return MaterialPageRoute(builder: (context) => const AddNewLessonView());
    case AddNewExamView.routeName:
      return MaterialPageRoute(builder: (context) => const AddNewExamView());
    case ExamResultsView.routeName:
      return MaterialPageRoute(builder: (context) => const ExamResultsView());
    case ExamDetailsView.routeName:
      final examId = settings.arguments as String?;
      return MaterialPageRoute(
        builder: (context) => ExamDetailsView(examId: examId ?? ''),
      );
    case TeacherClassesView.routeName:
      return MaterialPageRoute(
        builder: (context) => const TeacherClassesView(),
      );
    case ScusseView.routeName:
      return MaterialPageRoute(builder: (context) => const ScusseView());
    case AddHomeworkView.routeName:
      return MaterialPageRoute(builder: (context) => const AddHomeworkView());
    case TakeAttendanceView.routeName:
      return MaterialPageRoute(
        builder: (context) => const TakeAttendanceView(),
      );
    case AttendanceMethodView.routeName:
      {
        final args = settings.arguments;
        if (args is AttendanceMethodViewArgs) {
          return MaterialPageRoute(
            builder: (context) => AttendanceMethodView(
              teacherClass: args.teacherClass,
              lessonId: args.lessonId,
            ),
          );
        } else if (args is TeacherClassModel) {
          return MaterialPageRoute(
            builder: (context) => AttendanceMethodView(teacherClass: args),
          );
        }
        return MaterialPageRoute(builder: (context) => const SplashView());
      }
    case ManualAttendanceView.routeName:
      {
        final args = settings.arguments as ManualAttendanceViewArgs?;
        if (args != null) {
          return MaterialPageRoute(
            builder: (context) => ManualAttendanceView(
              teacherClass: args.teacherClass,
              session: args.session,
            ),
          );
        }
        return MaterialPageRoute(builder: (context) => const SplashView());
      }

    case GenerateQrCodeView.routeName:
      {
        final session = settings.arguments as AttendanceSessionModel?;
        if (session != null) {
          return MaterialPageRoute(
            builder: (context) => GenerateQrCodeView(session: session),
          );
        }
        return MaterialPageRoute(builder: (context) => const SplashView());
      }

    case EntryCodeView.routeName:
      {
        final session = settings.arguments as AttendanceSessionModel?;
        if (session != null) {
          return MaterialPageRoute(
            builder: (context) => EntryCodeView(session: session),
          );
        }
        return MaterialPageRoute(builder: (context) => const SplashView());
      }

    case AttendanceReportView.routeName:
      return MaterialPageRoute(
        builder: (context) => const AttendanceReportView(),
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
      return MaterialPageRoute(builder: (context) => const SettingsView());

    case NotificationsView.routeName:
      return MaterialPageRoute(builder: (context) => const NotificationsView());
    case MessagesView.routeName:
      return MaterialPageRoute(builder: (context) => const MessagesView());
    case ChatView.routeName:
      return MaterialPageRoute(
        builder: (context) => ChatView(conversation: settings.arguments),
      );
    case GradeSubmissionView.routeName:
      return MaterialPageRoute(
        builder: (context) => const GradeSubmissionView(),
      );
    case SmartTutorView.routeName:
      return MaterialPageRoute(builder: (context) => const SmartTutorView());
    default:
      return MaterialPageRoute(builder: (context) => const SplashView());
  }
}
