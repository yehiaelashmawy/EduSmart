class ParentWeeklyScheduleModel {
  final String childId;
  final String childName;
  final List<ParentWeeklyScheduleDay> weeklySchedule;
  final List<ParentClassModel> todayClasses;
  final List<ParentClassModel> tomorrowClasses;

  ParentWeeklyScheduleModel({
    required this.childId,
    required this.childName,
    required this.weeklySchedule,
    required this.todayClasses,
    required this.tomorrowClasses,
  });

  factory ParentWeeklyScheduleModel.fromJson(Map<String, dynamic> json) {
    return ParentWeeklyScheduleModel(
      childId: json['childId'] ?? '',
      childName: json['childName'] ?? '',
      weeklySchedule: (json['weeklySchedule'] as List?)
              ?.map((e) => ParentWeeklyScheduleDay.fromJson(e))
              .toList() ??
          [],
      todayClasses: (json['todayClasses'] as List?)
              ?.map((e) => ParentClassModel.fromJson(e))
              .toList() ??
          [],
      tomorrowClasses: (json['tomorrowClasses'] as List?)
              ?.map((e) => ParentClassModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ParentWeeklyScheduleDay {
  final String dayName;
  final String dayNameAr;
  final List<ParentClassModel> classes;

  ParentWeeklyScheduleDay({
    required this.dayName,
    required this.dayNameAr,
    required this.classes,
  });

  factory ParentWeeklyScheduleDay.fromJson(Map<String, dynamic> json) {
    return ParentWeeklyScheduleDay(
      dayName: json['dayName'] ?? '',
      dayNameAr: json['dayNameAr'] ?? '',
      classes: (json['classes'] as List?)
              ?.map((e) => ParentClassModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ParentClassModel {
  final String subjectName;
  final String subjectNameAr;
  final String startTime;
  final String endTime;
  final String roomNumber;
  final String teacherName;
  final String period;
  final String? status;
  final String? classDate;

  ParentClassModel({
    required this.subjectName,
    required this.subjectNameAr,
    required this.startTime,
    required this.endTime,
    required this.roomNumber,
    required this.teacherName,
    required this.period,
    this.status,
    this.classDate,
  });

  factory ParentClassModel.fromJson(Map<String, dynamic> json) {
    return ParentClassModel(
      subjectName: json['subjectName'] ?? '',
      subjectNameAr: json['subjectNameAr'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      teacherName: json['teacherName'] ?? '',
      period: json['period'] ?? '',
      status: json['status'],
      classDate: json['classDate'],
    );
  }
}
