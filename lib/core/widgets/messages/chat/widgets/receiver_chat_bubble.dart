import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/size_config.dart';
import 'package:school_system/core/utils/theme_manager.dart';
import '../models/chat_message_model.dart';
import 'chat_image_attachment.dart';
import 'chat_file_attachment.dart';

class ReceiverChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ReceiverChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const CircleAvatar(
          radius: 12,
          backgroundColor: Color(0xffADD8E6),
          child: Icon(Icons.person, size: 16, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.imageUrl != null)
                ChatImageAttachment(message: message, width: 250)
              else if (message.attachedFileName != null)
                ChatFileAttachment(
                  message: message,
                  isSender: false,
                  maxWidth: 250,
                ),
              if (message.text.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ThemeManager.isDarkMode
                        ? AppColors.white
                        : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(16),
                    ),
                    border: ThemeManager.isDarkMode
                        ? Border.all(
                            color: AppColors.lightGrey.withOpacity(0.3),
                          )
                        : Border.all(color: const Color(0xffE2E8F0)),
                    boxShadow: ThemeManager.isDarkMode
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Text(
                    message.text,
                    style: AppTextStyle.regular14.copyWith(
                      color: ThemeManager.isDarkMode
                          ? Colors.white
                          : const Color(0xff334155),
                      height: 1.5,
                      fontSize: SizeConfig.getResponsiveFontSize(
                        context,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                message.time,
                style: AppTextStyle.regular12.copyWith(
                  color: AppColors.grey.withOpacity(0.6),
                  fontSize: SizeConfig.getResponsiveFontSize(
                    context,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
