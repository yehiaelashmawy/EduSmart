import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/helper/shared_prefs_helper.dart';
import 'package:school_system/core/widgets/messages/data/messages_repo.dart';
import 'package:school_system/core/widgets/messages/message_model.dart';
import 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final MessagesRepo messagesRepo;
  final Map<String, String> _readConversationLastPreviews = {};
  Timer? _pollingTimer;

  MessagesCubit(this.messagesRepo) : super(MessagesInitial()) {
    startPolling();
  }

  Future<void> fetchMessagesConversations({bool isSilent = false}) async {
    final token = SharedPrefsHelper.token;
    if (token == null || token.isEmpty) {
      return;
    }
    if (!isSilent) {
      emit(MessagesLoading());
    }
    try {
      final messages = await messagesRepo.fetchMessagesConversations();
      final mergedMessages = messages.map((message) {
        final lastReadPreview = _readConversationLastPreviews[message.senderOid];
        if (lastReadPreview != null) {
          if (lastReadPreview == message.preview) {
            return message.copyWith(unreadCount: 0);
          } else {
            _readConversationLastPreviews.remove(message.senderOid);
          }
        }
        return message;
      }).toList();
      emit(MessagesSuccess(messages: mergedMessages));
    } catch (e) {
      if (!isSilent || state is! MessagesSuccess) {
        String errMessage = e.toString();
        if (errMessage.startsWith('Exception: ')) {
          errMessage = errMessage.replaceFirst('Exception: ', '');
        }
        emit(MessagesFailure(errMessage: errMessage));
      }
    }
  }

  void startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      fetchMessagesConversations(isSilent: true);
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void markConversationAsRead(String conversationUserOid, {String? lastMessagePreview}) {
    if (conversationUserOid.isEmpty) return;

    final current = state;
    if (current is! MessagesSuccess) return;

    if (lastMessagePreview != null) {
      _readConversationLastPreviews[conversationUserOid] = lastMessagePreview;
    } else {
      final conversation = current.messages.firstWhere(
        (m) => m.senderOid == conversationUserOid,
        orElse: () => const MessageModel(name: '', role: '', preview: '', time: ''),
      );
      if (conversation.name.isNotEmpty) {
        _readConversationLastPreviews[conversationUserOid] = conversation.preview;
      }
    }

    final updated = current.messages.map((message) {
      if (message.senderOid == conversationUserOid) {
        return message.copyWith(unreadCount: 0);
      }
      return message;
    }).toList();

    emit(MessagesSuccess(messages: updated));
  }

  Future<void> removeMessage(MessageModel message) async {
    final current = state;
    if (current is! MessagesSuccess) return;

    if (message.oid.trim().isNotEmpty) {
      await messagesRepo.deleteMessage(message.oid);
    }

    final updated = current.messages.where((m) {
      if (message.oid.trim().isNotEmpty) {
        return m.oid != message.oid;
      }
      return m.senderOid != message.senderOid;
    }).toList();

    emit(MessagesSuccess(messages: updated));
  }

  @override
  Future<void> close() {
    stopPolling();
    return super.close();
  }
}
