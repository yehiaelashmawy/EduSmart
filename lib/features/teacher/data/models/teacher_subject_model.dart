class SubjectTeacherModel {
  final String oid;
  final String fullName;
  final String email;

  SubjectTeacherModel({
    required this.oid,
    required this.fullName,
    required this.email,
  });

  factory SubjectTeacherModel.fromJson(Map<String, dynamic> json) {
    return SubjectTeacherModel(
      oid: (json['oid'] ?? '').toString(),
      fullName: (json['fullName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
    );
  }
}

class TeacherSubjectModel {
  final String oid;
  final String name;
  final String code;
  final int teachersCount;
  final int activeClassesCount;
  final List<SubjectTeacherModel> teachers;

  TeacherSubjectModel({
    required this.oid,
    required this.name,
    required this.code,
    required this.teachersCount,
    required this.activeClassesCount,
    required this.teachers,
  });

  factory TeacherSubjectModel.fromJson(Map<String, dynamic> json) {
    return TeacherSubjectModel(
      oid: (json['oid'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      code: (json['code'] ?? '').toString(),
      teachersCount: (json['teachersCount'] as num?)?.toInt() ?? 0,
      activeClassesCount: (json['activeClassesCount'] as num?)?.toInt() ?? 0,
      teachers:
          (json['teachers'] as List?)
              ?.whereType<Map>()
              .map(
                (e) => SubjectTeacherModel.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList() ??
          [],
    );
  }
}
