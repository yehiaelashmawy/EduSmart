import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/theme_manager.dart';
import 'message_item.dart';
import 'message_model.dart';

const List<MessageModel> allMessages = [
  MessageModel(
    name: 'Sarah Jenkins',
    role: '(Parent)',
    preview: 'Hello, will the field trip next week...',
    time: '10:45 AM',
    unreadCount: 2,
    isOnline: true,
  ),
  MessageModel(
    name: 'David Miller',
    role: '(Student)',
    preview: "I've submitted my essay for the English...",
    time: '9:20 AM',
  ),
  MessageModel(
    name: 'Robert Wilson',
    role: '(Parent)',
    preview: "Thank you for the update on Leo's...",
    time: 'Yesterday',
    unreadCount: 1,
  ),
  MessageModel(
    name: 'Emma Thompson',
    role: '(Student)',
    preview: 'Can we reschedule the extra tutoring...',
    time: 'Yesterday',
  ),
  MessageModel(
    name: 'Lisa Garcia',
    role: '(Parent)',
    preview: 'Is the permission slip required for the loc...',
    time: 'Oct 24',
  ),
  MessageModel(
    name: 'Kevin Adams',
    role: '(Student)',
    preview: 'I forgot my textbook in the locker. Can I...',
    time: 'Oct 23',
  ),
];

class MessagesViewBody extends StatelessWidget {
  const MessagesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Container(
            decoration: BoxDecoration(
              color: ThemeManager.isDarkMode
                  ? AppColors.darkBlue
                  : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: ThemeManager.isDarkMode
                  ? Border.all(
                      color: AppColors.lightGrey.withValues(alpha: 0.5),
                    )
                  : Border.all(color: const Color(0xffE2E8F0)),
              boxShadow: ThemeManager.isDarkMode
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search conversations',
                hintStyle: AppTextStyle.regular14.copyWith(
                  color: AppColors.grey,
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),

        // TabBar
        TabBar(
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: AppColors.grey,
          labelStyle: AppTextStyle.bold16,
          unselectedLabelStyle: AppTextStyle.semiBold16,
          indicatorColor: AppColors.primaryColor,
          indicatorWeight: 3,
          dividerColor: ThemeManager.isDarkMode
              ? AppColors.lightGrey
              : const Color(0xffE2E8F0),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Students'),
            Tab(text: 'Parents'),
          ],
        ),

        // Lists
        Expanded(
          child: TabBarView(
            children: [
              // All
              ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: allMessages.length,
                itemBuilder: (context, index) =>
                    MessageItem(message: allMessages[index]),
              ),
              // Students
              ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: allMessages
                    .where((m) => m.role == '(Student)')
                    .length,
                itemBuilder: (context, index) {
                  final students = allMessages
                      .where((m) => m.role == '(Student)')
                      .toList();
                  return MessageItem(message: students[index]);
                },
              ),
              // Parents
              ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: allMessages
                    .where((m) => m.role == '(Parent)')
                    .length,
                itemBuilder: (context, index) {
                  final parents = allMessages
                      .where((m) => m.role == '(Parent)')
                      .toList();
                  return MessageItem(message: parents[index]);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
