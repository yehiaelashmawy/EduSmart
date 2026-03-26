import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/widgets/custom_app_bar.dart';
import 'messages_view_body.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});
  static const String routeName = 'messages_view';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Column(
            children: const [
              CustomAppBar(title: 'Messages', showBackButton: false),
              Expanded(child: MessagesViewBody()),
            ],
          ),
        ),
      ),
    );
  }
}
