import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/theme_manager.dart';
import 'chat_view_body.dart';
import 'widgets/chat_app_bar_title.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});
  static const String routeName = 'chat_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.isDarkMode
          ? AppColors.backgroundColor
          : AppColors.white,
      appBar: AppBar(
        backgroundColor: ThemeManager.isDarkMode
            ? AppColors.backgroundColor
            : AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ThemeManager.isDarkMode ? Colors.white : AppColors.darkBlue,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const ChatAppBarTitle(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.videocam_outlined,
              color: ThemeManager.isDarkMode
                  ? Colors.white
                  : AppColors.darkBlue,
              size: 28,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: ThemeManager.isDarkMode
                  ? Colors.white
                  : AppColors.darkBlue,
              size: 26,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: ThemeManager.isDarkMode
                ? AppColors.lightGrey.withValues(alpha: 0.3)
                : const Color(0xffE2E8F0),
            height: 1.0,
          ),
        ),
      ),
      body: const SafeArea(child: ChatViewBody()),
    );
  }
}
