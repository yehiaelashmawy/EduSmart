class ScheduleDay {
  final String dayName;
  final String dayNumber;
  final int classCount;
  final bool isSelected;

  ScheduleDay({
    required this.dayName,
    required this.dayNumber,
    required this.classCount,
    this.isSelected = false,
  });
}

class CurriculumItem {
  final String startTime;
  final String endTime;
  final String title;
  final String subtitle;
  final String type;
  final String? alertText;
  final String? iconString;
  final bool isActive;
  final List<String> avatars;

  CurriculumItem({
    required this.startTime,
    required this.endTime,
    required this.title,
    this.subtitle = '',
    required this.type,
    this.alertText,
    this.iconString,
    this.isActive = false,
    this.avatars = const [],
  });
}
