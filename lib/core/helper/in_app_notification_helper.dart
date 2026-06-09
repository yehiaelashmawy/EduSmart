import 'dart:async';
import 'package:flutter/material.dart';
import 'package:school_system/core/helper/navigator_key.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/theme_manager.dart';
import 'package:school_system/core/widgets/messages/chat/chat_view.dart';
import 'package:school_system/core/widgets/messages/message_model.dart';
import 'package:school_system/core/widgets/notifications/notification_model.dart';
import 'package:school_system/core/widgets/notifications/notifications_view.dart';

class InAppNotificationHelper {
  // Keep track of the active chat senderOid to suppress notifications for the active screen
  static String? activeChatUserOid;

  static OverlayEntry? _currentOverlayEntry;
  static Timer? _autoDismissTimer;

  static void showNotification({
    required String title,
    required String body,
    required bool isMessage,
    required dynamic payload,
  }) {
    final overlayState = navigatorKey.currentState?.overlay;
    if (overlayState == null) return;

    // Clean up any existing notification first
    dismissCurrent();

    _currentOverlayEntry = OverlayEntry(
      builder: (context) {
        return _InAppNotificationBanner(
          title: title,
          body: body,
          isMessage: isMessage,
          payload: payload,
          onDismiss: () {
            dismissCurrent();
          },
        );
      },
    );

    overlayState.insert(_currentOverlayEntry!);
  }

  static void dismissCurrent() {
    _autoDismissTimer?.cancel();
    _autoDismissTimer = null;
    if (_currentOverlayEntry != null) {
      _currentOverlayEntry!.remove();
      _currentOverlayEntry = null;
    }
  }
}

class _InAppNotificationBanner extends StatefulWidget {
  final String title;
  final String body;
  final bool isMessage;
  final dynamic payload;
  final VoidCallback onDismiss;

  const _InAppNotificationBanner({
    required this.title,
    required this.body,
    required this.isMessage,
    required this.payload,
    required this.onDismiss,
  });

  @override
  State<_InAppNotificationBanner> createState() => _InAppNotificationBannerState();
}

class _InAppNotificationBannerState extends State<_InAppNotificationBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();

    // Auto dismiss after 3.5 seconds
    _dismissTimer = Timer(const Duration(milliseconds: 3500), () {
      _animateOut();
    });
  }

  Future<void> _animateOut() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismiss();
  }

  void _onTap() {
    _dismissTimer?.cancel();
    _controller.reverse().then((_) {
      widget.onDismiss();
      // Perform routing
      final navState = navigatorKey.currentState;
      if (navState == null) return;

      if (widget.isMessage && widget.payload is MessageModel) {
        navState.pushNamed(
          ChatView.routeName,
          arguments: widget.payload as MessageModel,
        );
      } else if (!widget.isMessage) {
        navState.pushNamed(NotificationsView.routeName);
      }
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = ThemeManager.isDarkMode;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Positioned(
      top: statusBarHeight + 12,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Dismissible(
            key: const ValueKey('in_app_notification'),
            direction: DismissDirection.up,
            onDismissed: (_) {
              _dismissTimer?.cancel();
              widget.onDismiss();
            },
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _onTap,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xff1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xff334155)
                          : const Color(0xffE2E8F0),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Icon/Avatar on the left
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: widget.isMessage
                              ? AppColors.primaryColor.withValues(alpha: 0.12)
                              : _getAlertBgColor(widget.payload),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.isMessage
                              ? Icons.chat_bubble_outline_rounded
                              : _getAlertIcon(widget.payload),
                          color: widget.isMessage
                              ? AppColors.primaryColor
                              : _getAlertColor(widget.payload),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Content text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isDark ? Colors.white : const Color(0xff0F172A),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.isMessage
                                        ? AppColors.primaryColor.withValues(alpha: 0.12)
                                        : Colors.amber.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    widget.isMessage ? 'Message' : 'Alert',
                                    style: TextStyle(
                                      color: widget.isMessage
                                          ? AppColors.primaryColor
                                          : Colors.amber[800],
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              widget.body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDark ? const Color(0xff94A3B8) : const Color(0xff64748B),
                                fontSize: 13,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getAlertColor(dynamic payload) {
    if (payload is NotificationModel) {
      return payload.iconColor;
    }
    return AppColors.primaryColor;
  }

  Color _getAlertBgColor(dynamic payload) {
    if (payload is NotificationModel) {
      return payload.iconBackgroundColor;
    }
    return AppColors.primaryColor.withValues(alpha: 0.15);
  }

  IconData _getAlertIcon(dynamic payload) {
    if (payload is NotificationModel) {
      return payload.iconData;
    }
    return Icons.notifications_none_outlined;
  }
}
