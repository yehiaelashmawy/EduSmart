import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/size_config.dart';
import 'package:school_system/core/utils/theme_manager.dart';
import 'package:school_system/core/widgets/smart_tutor/ai_markdown_body.dart';
import '../models/chat_message_model.dart';
import 'chat_image_attachment.dart';
import 'chat_file_attachment.dart';

class ReceiverChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isAi;

  const ReceiverChatBubble({
    super.key,
    required this.message,
    this.isAi = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeManager.isDarkMode;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAvatar(),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isAi)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        'SmartTutor AI',
                        style: AppTextStyle.semiBold12.copyWith(
                          color: AppColors.primaryColor,
                          fontSize: SizeConfig.getResponsiveFontSize(
                            context,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              AppColors.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'AI',
                          style: AppTextStyle.bold10.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: SizeConfig.getResponsiveFontSize(
                              context,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (message.imageUrl != null)
                ChatImageAttachment(message: message, width: 250)
              else if (message.attachedFileName != null)
                ChatFileAttachment(
                  message: message,
                  isSender: false,
                  maxWidth: 250,
                ),
              if (message.text.isNotEmpty) _buildMessageBody(context, isDark),
              const SizedBox(height: 6),
              _buildFooter(context, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    if (isAi) {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.auto_awesome, size: 14, color: Colors.white),
      );
    }

    return const CircleAvatar(
      radius: 12,
      backgroundColor: Color(0xffADD8E6),
      child: Icon(Icons.person, size: 16, color: Colors.white),
    );
  }

  Widget _buildMessageBody(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.white : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: isDark
            ? Border.all(
                color: AppColors.lightGrey.withValues(alpha: 0.3),
              )
            : Border.all(color: const Color(0xffE2E8F0)),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: isAi
          ? AiMarkdownBody(text: message.text)
          : Text(
              message.text,
              style: AppTextStyle.regular14.copyWith(
                color: isDark ? Colors.white : const Color(0xff334155),
                height: 1.5,
                fontSize: SizeConfig.getResponsiveFontSize(
                  context,
                  fontSize: 14,
                ),
              ),
            ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Row(
      children: [
        Text(
          message.time,
          style: AppTextStyle.regular12.copyWith(
            color: AppColors.grey.withValues(alpha: 0.6),
            fontSize: SizeConfig.getResponsiveFontSize(
              context,
              fontSize: 10,
            ),
          ),
        ),
        if (isAi) ...[
          const Spacer(),
          _FooterAction(
            icon: Icons.copy_rounded,
            label: 'Copy',
            onTap: () {
              Clipboard.setData(ClipboardData(text: message.text));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Response copied to clipboard',
                    style: AppTextStyle.regular12.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

class _FooterAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FooterAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: AppColors.grey.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyle.regular12.copyWith(
                color: AppColors.grey.withValues(alpha: 0.6),
                fontSize: SizeConfig.getResponsiveFontSize(
                  context,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
