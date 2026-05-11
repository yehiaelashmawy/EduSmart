class ChildrenAttendanceModel {
  final String parentName;
  final List<ChildAttendanceModel> children;

  ChildrenAttendanceModel({
    required this.parentName,
    required this.children,
  });

  factory ChildrenAttendanceModel.fromJson(Map<String, dynamic> json) {
    return ChildrenAttendanceModel(
      parentName: json['parentName'] ?? '',
      children: (json['children'] as List? ?? [])
          .map((e) => ChildAttendanceModel.fromJson(e))
          .toList(),
    );
  }
}

class ChildAttendanceModel {
  final String studentOid;
  final String studentName;
  final String gradeLevel;
  final double gpa;
  final double attendance;
  final int subjectsCount;
  final AttendanceStatsModel attendanceStats;

  ChildAttendanceModel({
    required this.studentOid,
    required this.studentName,
    required this.gradeLevel,
    required this.gpa,
    required this.attendance,
    required this.subjectsCount,
    required this.attendanceStats,
  });

  factory ChildAttendanceModel.fromJson(Map<String, dynamic> json) {
    return ChildAttendanceModel(
      studentOid: json['studentOid'] ?? '',
      studentName: json['studentName'] ?? '',
      gradeLevel: json['gradeLevel'] ?? '',
      gpa: (json['gpa'] as num?)?.toDouble() ?? 0,
      attendance: (json['attendance'] as num?)?.toDouble() ?? 0,
      subjectsCount: json['subjectsCount'] ?? 0,
      attendanceStats: AttendanceStatsModel.fromJson(json['attendanceStats'] ?? {}),
    );
  }
}

class AttendanceStatsModel {
  final double overallAttendancePercentage;
  final int totalPresentDays;
  final int totalAbsentDays;
  final int totalLateDays;
  final List<AttendanceRecordModel> recentRecords;
  final String? warningMessage;

  AttendanceStatsModel({
    required this.overallAttendancePercentage,
    required this.totalPresentDays,
    required this.totalAbsentDays,
    required this.totalLateDays,
    required this.recentRecords,
    this.warningMessage,
  });

  factory AttendanceStatsModel.fromJson(Map<String, dynamic> json) {
    return AttendanceStatsModel(
      overallAttendancePercentage:
          (json['overallAttendancePercentage'] as num?)?.toDouble() ?? 0,
      totalPresentDays: json['totalPresentDays'] ?? 0,
      totalAbsentDays: json['totalAbsentDays'] ?? 0,
      totalLateDays: json['totalLateDays'] ?? 0,
      recentRecords: (json['recentRecords'] as List? ?? [])
          .map((e) => AttendanceRecordModel.fromJson(e))
          .toList(),
      warningMessage: json['warningMessage'],
    );
  }
}

class AttendanceRecordModel {
  final DateTime date;
  final String dayName;
  final String status;

  AttendanceRecordModel({
    required this.date,
    required this.dayName,
    required this.status,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      dayName: json['dayName'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
