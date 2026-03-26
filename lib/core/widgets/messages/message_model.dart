class MessageModel {
  final String name;
  final String role; // e.g. "(Parent)" or "(Student)"
  final String preview;
  final String time;
  final int unreadCount;
  final bool isOnline;

  const MessageModel({
    required this.name,
    required this.role,
    required this.preview,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}
