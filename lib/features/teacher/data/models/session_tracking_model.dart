class SessionTrackingModel {
  final String sessionId;
  final int method;
  final String? date;
  final int totalStudents;
  final int presentCount;
  final int absentCount;
  final int lateCount;
  final int notRecorded;
  final List<SessionTrackingStudentModel> students;

  SessionTrackingModel({
    required this.sessionId,
    required this.method,
    this.date,
    required this.totalStudents,
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
    required this.notRecorded,
    required this.students,
  });

  factory SessionTrackingModel.fromJson(Map<String, dynamic> json) {
    return SessionTrackingModel(
      sessionId: json['sessionId'] as String? ?? '',
      method: json['method'] as int? ?? 0,
      date: json['date'] as String?,
      totalStudents: json['totalStudents'] as int? ?? 0,
      presentCount: json['presentCount'] as int? ?? 0,
      absentCount: json['absentCount'] as int? ?? 0,
      lateCount: json['lateCount'] as int? ?? 0,
      notRecorded: json['notRecorded'] as int? ?? 0,
      students: (json['students'] as List<dynamic>?)
              ?.map((e) =>
                  SessionTrackingStudentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SessionTrackingStudentModel {
  final String studentOid;
  final String studentName;
  final String status;
  final String? checkInTime;
  final String? remarks;

  SessionTrackingStudentModel({
    required this.studentOid,
    required this.studentName,
    required this.status,
    this.checkInTime,
    this.remarks,
  });

  factory SessionTrackingStudentModel.fromJson(Map<String, dynamic> json) {
    return SessionTrackingStudentModel(
      studentOid: json['studentOid'] as String? ?? '',
      studentName: json['studentName'] as String? ?? '',
      status: json['status'] as String? ?? 'NotRecorded',
      checkInTime: json['checkInTime'] as String?,
      remarks: json['remarks'] as String?,
    );
  }
}
