class AttendanceSessionModel {
  final String sessionId;
  final String classOid;
  final String lessonOid;
  final String lessonName;
  final String className;
  final int method;
  final String? qrCodeBase64;
  final List<int>? randomNumbers;
  final String? expiresAt;
  final List<SessionStudentModel> students;

  AttendanceSessionModel({
    required this.sessionId,
    required this.classOid,
    required this.lessonOid,
    required this.lessonName,
    required this.className,
    required this.method,
    this.qrCodeBase64,
    this.randomNumbers,
    this.expiresAt,
    required this.students,
  });

  factory AttendanceSessionModel.fromJson(Map<String, dynamic> json) {
    final studentsRaw = json['students'];
    return AttendanceSessionModel(
      sessionId: (json['sessionId'] ?? '').toString(),
      classOid: (json['classOid'] ?? '').toString(),
      lessonOid: (json['lessonOid'] ?? '').toString(),
      lessonName: (json['lessonName'] ?? '').toString(),
      className: (json['className'] ?? '').toString(),
      method: int.tryParse(json['method']?.toString() ?? '1') ?? 1,
      qrCodeBase64: json['qrCodeBase64'] as String?,
      randomNumbers: (json['randomNumbers'] as List?)
          ?.map((e) => int.tryParse(e.toString()) ?? 0)
          .toList(),
      expiresAt: json['expiresAt']?.toString(),
      students: studentsRaw is List
          ? studentsRaw
                .whereType<Map>()
                .map(
                  (s) =>
                      SessionStudentModel.fromJson(s.cast<String, dynamic>()),
                )
                .toList()
          : [],
    );
  }
}

class SessionStudentModel {
  final String studentOid;
  final String studentName;

  SessionStudentModel({required this.studentOid, required this.studentName});

  factory SessionStudentModel.fromJson(Map<String, dynamic> json) {
    return SessionStudentModel(
      studentOid: (json['studentOid'] ?? '').toString(),
      studentName: (json['studentName'] ?? '').toString(),
    );
  }
}
