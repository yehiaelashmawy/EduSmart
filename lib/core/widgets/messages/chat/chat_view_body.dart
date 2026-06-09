import 'dart:async';
import 'package:flutter/material.dart';
import 'package:school_system/core/helper/shared_prefs_helper.dart';
import 'package:school_system/core/helper/in_app_notification_helper.dart';
import 'package:school_system/core/utils/theme_manager.dart';
import 'package:school_system/core/widgets/messages/chat/data/chat_repo.dart';
import 'package:school_system/core/widgets/messages/message_model.dart';
import 'package:school_system/core/widgets/messages/manager/messages_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'models/chat_message_model.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/date_separator.dart';
import 'package:file_picker/file_picker.dart';

class ChatViewBody extends StatefulWidget {
  final MessageModel? conversation;
  final MessagesCubit? messagesCubit;

  const ChatViewBody({super.key, this.conversation, this.messagesCubit});

  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  final ScrollController _scrollController = ScrollController();
  final ChatRepo _chatRepo = ChatRepo();
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _pollingTimer;

  final List<ChatMessageModel> _messages = [];

  @override
  void initState() {
    super.initState();
    InAppNotificationHelper.activeChatUserOid = widget.conversation?.senderOid;
    _loadThread();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _loadThread(isSilent: true);
    });
  }

  Future<void> _loadThread({bool isSilent = false}) async {
    final currentUserOid = (SharedPrefsHelper.userId ?? '').trim();
    final otherUserOid = (widget.conversation?.senderOid ?? '').trim();

    if (currentUserOid.isEmpty || otherUserOid.isEmpty) {
      if (!isSilent) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Unable to open chat. Missing user data.';
        });
      }
      return;
    }

    if (!isSilent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final thread = await _chatRepo.fetchThread(
        currentUserOid: currentUserOid,
        otherUserOid: otherUserOid,
      );

      final mappedMessages = thread.map((message) {
        final dt = message.sentAt;
        final hour = dt?.hour ?? 0;
        final minute = dt?.minute ?? 0;
        final displayHour = hour == 0
            ? 12
            : hour > 12
            ? hour - 12
            : hour;
        final suffix = hour >= 12 ? 'PM' : 'AM';
        final formattedTime =
            '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $suffix';

        return ChatMessageModel(
          oid: message.oid,
          text: message.content,
          time: formattedTime,
          isSender: message.senderOid == currentUserOid,
        );
      }).toList();

      if (!mounted) return;

      final wasLength = _messages.length;

      setState(() {
        _messages
          ..clear()
          ..addAll(mappedMessages);
        _isLoading = false;
      });

      if (_messages.isNotEmpty && widget.messagesCubit != null && widget.conversation != null) {
        widget.messagesCubit!.markConversationAsRead(
          widget.conversation!.senderOid,
          lastMessagePreview: _messages.last.text,
        );
      }

      if (_messages.length > wasLength) {
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
    } catch (e) {
      if (!isSilent || _messages.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  void _sendMessage(String text, {PlatformFile? attachedFile}) {
    _sendMessageAsync(text, attachedFile: attachedFile);
  }

  Future<void> _sendMessageAsync(String text, {PlatformFile? attachedFile}) async {
    bool isImage = false;
    if (attachedFile != null) {
      isImage = [
        'jpg',
        'jpeg',
        'png',
        'gif',
        'webp',
      ].contains(attachedFile.extension?.toLowerCase());
    }

    final receiverOid = (widget.conversation?.senderOid ?? '').trim();
    if (receiverOid.isEmpty) {
      return;
    }

    final content = text.isNotEmpty
        ? text
        : (attachedFile != null ? 'Attachment: ${attachedFile.name}' : '');
    if (content.isEmpty) {
      return;
    }

    final tempMessage = ChatMessageModel(
      oid: '',
      text: content,
      time: TimeOfDay.now().format(context),
      isSender: true,
      attachedFileName: attachedFile?.name,
      attachedFilePath: attachedFile?.path,
      imageUrl: isImage ? attachedFile?.path : null,
    );

    setState(() {
      _messages.add(tempMessage);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    try {
      await _chatRepo.sendMessage(
        receiverOid: receiverOid,
        subject: widget.conversation?.preview.isNotEmpty == true
            ? widget.conversation!.preview
            : 'Message',
        content: content,
      );
      await _loadThread(isSilent: true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  @override
  void dispose() {
    if (InAppNotificationHelper.activeChatUserOid == widget.conversation?.senderOid) {
      InAppNotificationHelper.activeChatUserOid = null;
    }
    _pollingTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showDeleteMessageSheet(ChatMessageModel message) async {
    final shouldDelete = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Message actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Double tap opened actions for this message.',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    'Delete message',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () => Navigator.pop(sheetContext, true),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldDelete != true || !mounted) return;

    if (message.oid.isEmpty) {
      setState(() {
        _messages.remove(message);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message removed')),
      );
      return;
    }

    try {
      await _chatRepo.deleteMessage(message.oid);
      if (!mounted) return;
      setState(() {
        _messages.remove(message);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message deleted')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      final skeletonMessages = List.generate(
        8,
        (index) => ChatMessageModel(
          text: 'This is a placeholder chat message.',
          time: '10:30 AM',
          isSender: index.isEven,
        ),
      );
      return Skeletonizer(
        enabled: true,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: ThemeManager.isDarkMode
                    ? const Color(0xff0F172A)
                    : const Color(0xffF8FAFC),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  children: [
                    const DateSeparator(dateText: 'TODAY'),
                    const SizedBox(height: 24),
                    ...skeletonMessages.map((msg) => ChatBubble(message: msg)),
                  ],
                ),
              ),
            ),
            ChatInputField(onSendMessage: (_, {attachedFile}) {}),
          ],
        ),
      );
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

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
                ..._messages.map(
                  (msg) => ChatBubble(
                    message: msg,
                    onDoubleTap: () => _showDeleteMessageSheet(msg),
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
