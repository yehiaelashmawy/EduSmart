import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/widgets/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/widgets/notifications/manager/notifications_cubit.dart';
import 'notifications_view_body.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});
  static const String routeName = 'notifications_view';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocProvider.value(
        value: context.read<NotificationsCubit>()..fetchNotifications(),
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SafeArea(
            child: Column(
              children: const [
                CustomAppBar(title: 'Notifications', showBackButton: false),
                SizedBox(height: 16),
                Expanded(child: NotificationsViewBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
