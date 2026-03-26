import 'package:flutter/material.dart';
import 'package:school_system/core/utils/theme_manager.dart';
import 'models/chat_message_model.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/date_separator.dart';

class ChatViewBody extends StatefulWidget {
  const ChatViewBody({super.key});

  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessageModel> _messages = [
  ChatMessageModel(
    text: "Hi Mr. Henderson, I'm working on the Calculus assignment. I'm a bit confused about the second problem on page 42 regarding the chain rule application.",
    time: "09:15 AM",
    isSender: false,
  ),
  ChatMessageModel(
    text: "Good morning Alex! Happy to help. Are you struggling with identifying the inner function or the actual differentiation step?",
    time: "09:18 AM",
    isSender: true,
  ),
  ChatMessageModel(
    text: "I think it's the inner function. It's a nested trigonometric function and it's getting a bit messy. I've attached a photo of my current work.",
    time: "09:19 AM",
    isSender: false,
  ),
  ChatMessageModel(
    text: "", // Image only
    imageUrl: "placeholder",
    time: "09:20 AM",
    isSender: false,
  ),
  ChatMessageModel(
    text: "I see it. You're actually very close! Try letting u = sin(x²) first. Then differentiate the outer cos(u) part. Give that a try and show me what you get.",
    time: "09:22 AM",
    isSender: true,
  ),
  ];

  void _sendMessage(String text) {
    setState(() {
      _messages.add(
        ChatMessageModel(
          text: text,
          time: TimeOfDay.now().format(context),
          isSender: true,
        ),
      );
    });

    // Animate to bottom after the list rebuilds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: ThemeManager.isDarkMode ? const Color(0xff0F172A) : const Color(0xffF8FAFC),
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 24),
              children: [
                const DateSeparator(dateText: 'TODAY'),
                const SizedBox(height: 24),
                ..._messages.map((msg) => ChatBubble(message: msg)),
              ],
            ),
          ),
        ),
        ChatInputField(onSendMessage: _sendMessage),
      ],
    );
  }
}
