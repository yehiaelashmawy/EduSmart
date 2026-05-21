import 'package:flutter/material.dart';
import '../models/chat_message_model.dart';
import 'sender_chat_bubble.dart';
import 'receiver_chat_bubble.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final VoidCallback? onDoubleTap;
  final bool isAi;

  const ChatBubble({
    super.key,
    required this.message,
    this.onDoubleTap,
    this.isAi = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 24.0,
          left: message.isSender ? 64 : 16,
          right: message.isSender ? 16 : 64,
        ),
        child: message.isSender
            ? SenderChatBubble(message: message)
            : ReceiverChatBubble(message: message, isAi: isAi),
      ),
    );
  }
}
