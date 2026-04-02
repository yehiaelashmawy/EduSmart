import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import '../models/chat_message_model.dart';

class ChatImageAttachment extends StatelessWidget {
  final ChatMessageModel message;
  final double width;

  const ChatImageAttachment({
    super.key,
    required this.message,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    if (message.imageUrl == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: message.imageUrl == "placeholder"
            ? Container(
                height: 150,
                width: width,
                color: const Color(0xffEBB486),
              )
            : GestureDetector(
                onTap: () {
                  if (message.imageUrl != null &&
                      message.imageUrl != "placeholder") {
                    OpenFilex.open(message.imageUrl!);
                  }
                },
                child: Container(
                  height: 150,
                  width: width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(message.imageUrl!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
