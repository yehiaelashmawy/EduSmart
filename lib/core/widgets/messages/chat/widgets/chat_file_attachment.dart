import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/theme_manager.dart';
import '../models/chat_message_model.dart';

class ChatFileAttachment extends StatelessWidget {
  final ChatMessageModel message;
  final bool isSender;
  final double maxWidth;

  const ChatFileAttachment({
    super.key,
    required this.message,
    required this.isSender,
    this.maxWidth = 200,
  });

  @override
  Widget build(BuildContext context) {
    if (message.attachedFileName == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          if (message.attachedFilePath != null) {
            OpenFilex.open(message.attachedFilePath!);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(maxWidth: maxWidth),
          decoration: BoxDecoration(
            color: isSender
                ? AppColors.primaryColor.withValues(alpha: 0.9)
                : ThemeManager.isDarkMode
                ? AppColors.white
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: isSender
                ? null
                : ThemeManager.isDarkMode
                ? Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3))
                : Border.all(color: const Color(0xffE2E8F0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.insert_drive_file,
                color: isSender ? Colors.white : AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message.attachedFileName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.regular14.copyWith(
                    color: isSender
                        ? Colors.white
                        : ThemeManager.isDarkMode
                        ? Colors.white
                        : const Color(0xff334155),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
