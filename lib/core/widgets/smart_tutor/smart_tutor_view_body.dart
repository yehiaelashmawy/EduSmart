import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_system/core/utils/theme_manager.dart';
import 'package:school_system/core/utils/app_constants.dart';
import '../messages/chat/models/chat_message_model.dart';
import '../messages/chat/widgets/chat_bubble.dart';
import '../messages/chat/widgets/chat_input_field.dart';
import '../messages/chat/widgets/date_separator.dart';

class SmartTutorViewBody extends StatefulWidget {
  const SmartTutorViewBody({super.key});

  @override
  State<SmartTutorViewBody> createState() => _SmartTutorViewBodyState();
}

class _SmartTutorViewBodyState extends State<SmartTutorViewBody> {
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessageModel> _messages = [
    ChatMessageModel(
      text:
          "Hello! I am SmartTutor AI. How can I assist you with your classes or subjects today?",
      time: "just now",
      isSender: false,
    ),
  ];

  bool _isLoading = false;

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessageModel(
          text: text,
          time: TimeOfDay.now().format(context),
          isSender: true,
        ),
      );
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final List<Map<String, String>> apiMessages = _messages.map((m) {
        return {"role": m.isSender ? "user" : "assistant", "content": m.text};
      }).toList();

      final response = await http.post(
        Uri.parse(AppConstants.groqApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConstants.groqApiKey}',
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": apiMessages,
          "temperature": 1,
          "max_completion_tokens": 1024,
          "top_p": 1,
          "stream": false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiText = data['choices'][0]['message']['content'];

        if (mounted) {
          setState(() {
            _messages.add(
              ChatMessageModel(
                text: aiText,
                time: TimeOfDay.now().format(context),
                isSender: false,
              ),
            );
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _messages.add(
              ChatMessageModel(
                text: "Sorry, I encountered an error: ${response.statusCode}",
                time: TimeOfDay.now().format(context),
                isSender: false,
              ),
            );
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessageModel(
              text: "Sorry, a network error occurred.",
              time: TimeOfDay.now().format(context),
              isSender: false,
            ),
          );
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
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
            color: ThemeManager.isDarkMode
                ? const Color(0xff0F172A)
                : const Color(0xffF8FAFC),
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 24),
              children: [
                const DateSeparator(dateText: 'TODAY'),
                const SizedBox(height: 24),
                ..._messages.map((msg) => ChatBubble(message: msg)),
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI is typing...',
                          style: TextStyle(
                            color: ThemeManager.isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        ChatInputField(onSendMessage: _sendMessage),
      ],
    );
  }
}
