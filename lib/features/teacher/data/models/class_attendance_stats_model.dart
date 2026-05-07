class ClassAttendanceStatsModel {
  final double averageAttendance;
  final int totalLessons;
  final int completedLessons;
  final List<StudentAttendanceSummaryModel> studentSummaries;

  ClassAttendanceStatsModel({
    required this.averageAttendance,
    required this.totalLessons,
    required this.completedLessons,
    required this.studentSummaries,
  });

  factory ClassAttendanceStatsModel.fromJson(Map<String, dynamic> json) {
    return ClassAttendanceStatsModel(
      averageAttendance: (json['averageAttendance'] as num?)?.toDouble() ?? 0,
      totalLessons: (json['totalLessons'] as num?)?.toInt() ?? 0,
      completedLessons: (json['completedLessons'] as num?)?.toInt() ?? 0,
      studentSummaries: (json['studentSummaries'] as List?)
              ?.map((e) => StudentAttendanceSummaryModel.fromJson(
                  (e as Map).cast<String, dynamic>()))
              .toList() ??
          [],
    );
  }
}

class StudentAttendanceSummaryModel {
  final String studentOid;
  final String studentName;
  final double attendancePercentage;
  final int presentCount;
  final int absentCount;
  final int lateCount;
  final String status;

  StudentAttendanceSummaryModel({
    required this.studentOid,
    required this.studentName,
    required this.attendancePercentage,
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
    required this.status,
  });

  factory StudentAttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceSummaryModel(
      studentOid: (json['studentOid'] ?? '').toString(),
      studentName: (json['studentName'] ?? '').toString(),
      attendancePercentage:
          (json['attendancePercentage'] as num?)?.toDouble() ?? 0,
      presentCount: (json['presentCount'] as num?)?.toInt() ?? 0,
      absentCount: (json['absentCount'] as num?)?.toInt() ?? 0,
      lateCount: (json['lateCount'] as num?)?.toInt() ?? 0,
      status: (json['status'] ?? '').toString(),
    );
  }
}
