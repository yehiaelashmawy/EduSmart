import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/teacher/presentation/views/add_new_lesson_view.dart';
import 'package:school_system/features/teacher/presentation/views/lesson_details_view.dart';
import 'package:school_system/features/teacher/presentation/views/student_list.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/classes-view_body.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/teacher_home_view_body.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/teacher_profile_view_body.dart';
import 'package:school_system/features/teacher/presentation/views/personal_information_view.dart';

class TeacherHomeView extends StatefulWidget {
  const TeacherHomeView({super.key});
  static const String routeName = 'teacher_home_view';

  @override
  State<TeacherHomeView> createState() => _TeacherHomeViewState();
}

class _TeacherHomeViewState extends State<TeacherHomeView> {
  int _currentIndex = 0;
  final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _classesNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _profileNavigatorKey =
      GlobalKey<NavigatorState>();

  late final List<Widget> _views = [
    Navigator(
      key: _homeNavigatorKey,
      onGenerateRoute: (settings) {
        Widget page;
        if (settings.name == AddNewLessonView.routeName) {
          page = const AddNewLessonView();
        } else {
          page = const TeacherHomeViewBody();
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    ),
    Navigator(
      key: _classesNavigatorKey,
      onGenerateRoute: (settings) {
        Widget page;
        if (settings.name == StudentList.routeName) {
          page = const StudentList();
        } else if (settings.name == LessonDetailsView.routeName) {
          page = const LessonDetailsView();
        } else {
          page = const ClassesViewBody();
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    ),
    const Center(child: Text('Messages View')),
    const Center(child: Text('Alerts View')),
    Navigator(
      key: _profileNavigatorKey,
      onGenerateRoute: (settings) {
        Widget page;
        if (settings.name == PersonalInformationView.routeName) {
          page = const PersonalInformationView();
        } else {
          page = const TeacherProfileViewBody();
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:
          _currentIndex == 0 &&
          !(_homeNavigatorKey.currentState?.canPop() ?? false),
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (_currentIndex == 0 &&
            _homeNavigatorKey.currentState?.canPop() == true) {
          _homeNavigatorKey.currentState?.pop();
        } else if (_currentIndex == 1 &&
            _classesNavigatorKey.currentState?.canPop() == true) {
          _classesNavigatorKey.currentState?.pop();
        } else if (_currentIndex == 4 &&
            _profileNavigatorKey.currentState?.canPop() == true) {
          _profileNavigatorKey.currentState?.pop();
        } else {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: IndexedStack(index: _currentIndex, children: _views),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              if (index == _currentIndex && index == 0) {
                _homeNavigatorKey.currentState?.popUntil(
                  (route) => route.isFirst,
                );
              } else if (index == _currentIndex && index == 1) {
                _classesNavigatorKey.currentState?.popUntil(
                  (route) => route.isFirst,
                );
              } else if (index == _currentIndex && index == 4) {
                _profileNavigatorKey.currentState?.popUntil(
                  (route) => route.isFirst,
                );
              }
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: AppColors.grey.withOpacity(0.6),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.home_outlined),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.home),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.school_outlined),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.school),
                ),
                label: 'Classes',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.chat_bubble_outline),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.chat_bubble),
                ),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.notifications_none),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.notifications),
                ),
                label: 'Alerts',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person_outline),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
