import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/size_config.dart';
import 'package:school_system/core/utils/theme_manager.dart';
import 'message_model.dart';

class MessageItem extends StatelessWidget {
  final MessageModel message;

  const MessageItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isUnread = message.unreadCount > 0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: ThemeManager.isDarkMode 
            ? (isUnread ? const Color(0xFF1E293B) : Colors.transparent)
            : (isUnread ? const Color(0xFFF8FAFC) : Colors.white),
        border: Border(
          bottom: BorderSide(
            color: ThemeManager.isDarkMode 
                ? AppColors.lightGrey.withOpacity(0.2) 
                : const Color(0xffF1F5F9),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.lightGrey.withOpacity(0.3),
                child: Icon(Icons.person, color: AppColors.grey, size: 32),
              ),
              if (message.isOnline)
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981), // Green
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ThemeManager.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              message.name,
                              style: AppTextStyle.bold16.copyWith(
                                color: AppColors.darkBlue,
                                fontSize: SizeConfig.getResponsiveFontSize(context, fontSize: 16),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            message.role,
                            style: AppTextStyle.regular14.copyWith(
                              color: AppColors.grey.withOpacity(0.6),
                              fontSize: SizeConfig.getResponsiveFontSize(context, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      message.time,
                      style: AppTextStyle.semiBold14.copyWith(
                        color: isUnread ? AppColors.primaryColor : AppColors.grey.withOpacity(0.7),
                        fontSize: SizeConfig.getResponsiveFontSize(context, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        message.preview,
                        style: isUnread
                            ? AppTextStyle.bold14.copyWith(
                                color: AppColors.darkBlue.withOpacity(0.9),
                                fontSize: SizeConfig.getResponsiveFontSize(context, fontSize: 14),
                              )
                            : AppTextStyle.regular14.copyWith(
                                color: AppColors.grey,
                                fontSize: SizeConfig.getResponsiveFontSize(context, fontSize: 14),
                              ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isUnread) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          message.unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
