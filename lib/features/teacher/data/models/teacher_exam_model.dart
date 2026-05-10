class TeacherExamModel {
  final String oid;
  final String name;
  final String description;
  final String type;
  final String subjectName;
  final String className;
  final String date;
  final String startTime;
  final String duration;
  final int maxScore;
  final int passingScore;
  final String status;
  final String room;
  final int studentsCount;
  final String instructions;
  final List<dynamic> materials;
  final dynamic statistics;

  TeacherExamModel({
    required this.oid,
    required this.name,
    required this.description,
    required this.type,
    required this.subjectName,
    required this.className,
    required this.date,
    required this.startTime,
    required this.duration,
    required this.maxScore,
    required this.passingScore,
    required this.status,
    required this.room,
    required this.studentsCount,
    required this.instructions,
    required this.materials,
    this.statistics,
  });

  factory TeacherExamModel.fromJson(Map<String, dynamic> json) {
    return TeacherExamModel(
      oid: json['oid'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      subjectName: json['subjectName'] ?? '',
      className: json['className'] ?? '',
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? '',
      duration: json['duration'] ?? '',
      maxScore: (json['maxScore'] ?? json['totalMarks'] ?? json['maxGrade'] ?? 0).toInt(),
      passingScore: (json['passingScore'] ?? json['passingMarks'] ?? 0).toInt(),
      status: json['status'] ?? '',
      room: json['room'] ?? '',
      studentsCount: json['studentsCount'] ?? 0,
      instructions: json['instructions'] ?? '',
      materials: json['materials'] ?? [],
      statistics: json['statistics'],
    );
  }
}
