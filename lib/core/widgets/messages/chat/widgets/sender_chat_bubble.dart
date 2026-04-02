import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/size_config.dart';
import '../models/chat_message_model.dart';
import 'chat_image_attachment.dart';
import 'chat_file_attachment.dart';

class SenderChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const SenderChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.imageUrl != null)
                ChatImageAttachment(message: message, width: 200)
              else if (message.attachedFileName != null)
                ChatFileAttachment(
                  message: message,
                  isSender: true,
                  maxWidth: 200,
                ),
              if (message.text.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: AppTextStyle.regular14.copyWith(
                      color: Colors.white,
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
        const SizedBox(width: 8),
        const CircleAvatar(
          radius: 12,
          backgroundColor: Color(0xffD0A785),
          child: Icon(Icons.person, size: 16, color: Colors.white),
        ),
      ],
    );
  }
}
