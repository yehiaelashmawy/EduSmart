import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/widgets/messages/messages_view.dart';
import 'package:school_system/core/widgets/notifications/notifications_view.dart';
import 'package:school_system/features/parent/presentation/views/widgets/parent_bottom_nav_bar.dart';
import 'package:school_system/features/parent/presentation/views/widgets/parent_home_view_body.dart';
import 'package:school_system/features/teacher/presentation/views/personal_information_view.dart';
import 'package:school_system/features/teacher/presentation/views/change_password_view.dart';
import 'package:school_system/features/teacher/presentation/views/settings_view.dart';

class ParentHomeView extends StatefulWidget {
  const ParentHomeView({super.key});
  static const String routeName = 'parent_home_view';

  @override
  State<ParentHomeView> createState() => _ParentHomeViewState();
}

class _ParentHomeViewState extends State<ParentHomeView> {
  int _currentIndex = 0;

  final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _childrenNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _messagesNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _alertsNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _profileNavigatorKey = GlobalKey<NavigatorState>();

  late final List<Widget> _views = [
    Navigator(
      key: _homeNavigatorKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (_) => const ParentHomeViewBody(),
        settings: settings,
      ),
    ),
    Navigator(
      key: _childrenNavigatorKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Center(
            child: Text(
              'My Children Coming Soon',
              style: TextStyle(color: AppColors.grey, fontSize: 18),
            ),
          ),
        ),
        settings: settings,
      ),
    ),
    Navigator(
      key: _messagesNavigatorKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (_) => const MessagesView(),
        settings: settings,
      ),
    ),
    Navigator(
      key: _alertsNavigatorKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (_) => const NotificationsView(),
        settings: settings,
      ),
    ),
    Navigator(
      key: _profileNavigatorKey,
      onGenerateRoute: (settings) {
        Widget page;
        if (settings.name == PersonalInformationView.routeName) {
          page = const PersonalInformationView();
        } else if (settings.name == ChangePasswordView.routeName) {
          page = const ChangePasswordView();
        } else if (settings.name == SettingsView.routeName) {
          page = const SettingsView();
        } else {
          page = Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: Text(
                'Parent Profile Coming Soon',
                style: TextStyle(color: AppColors.grey, fontSize: 18),
              ),
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    ),
  ];

  void _handleNavTap(int index) {
    if (index == _currentIndex) {
      final keys = {
        0: _homeNavigatorKey,
        1: _childrenNavigatorKey,
        2: _messagesNavigatorKey,
        3: _alertsNavigatorKey,
        4: _profileNavigatorKey,
      };
      keys[index]?.currentState?.popUntil((route) => route.isFirst);
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0 && !(_homeNavigatorKey.currentState?.canPop() ?? false),
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final navigatorKeys = {
          0: _homeNavigatorKey,
          1: _childrenNavigatorKey,
          2: _messagesNavigatorKey,
          3: _alertsNavigatorKey,
          4: _profileNavigatorKey,
        };
        final key = navigatorKeys[_currentIndex];
        if (key?.currentState?.canPop() == true) {
          key!.currentState!.pop();
        } else {
          setState(() => _currentIndex = 0);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: IndexedStack(index: _currentIndex, children: _views),
        bottomNavigationBar: ParentBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _handleNavTap,
        ),
      ),
    );
  }
}

