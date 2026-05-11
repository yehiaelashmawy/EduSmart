class ParentHomeworkModel {
  final String studentOid;
  final String studentName;
  final String subjectName;
  final String title;
  final DateTime dueDate;
  final String status;
  final double? grade;
  final double totalMarks;

  ParentHomeworkModel({
    required this.studentOid,
    required this.studentName,
    required this.subjectName,
    required this.title,
    required this.dueDate,
    required this.status,
    this.grade,
    required this.totalMarks,
  });

  factory ParentHomeworkModel.fromJson(Map<String, dynamic> json) {
    return ParentHomeworkModel(
      studentOid: json['studentOid'] ?? '',
      studentName: json['studentName'] ?? '',
      subjectName: json['subjectName'] ?? '',
      title: json['title'] ?? '',
      dueDate: DateTime.tryParse(json['dueDate'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? '',
      grade: (json['grade'] as num?)?.toDouble(),
      totalMarks: (json['totalMarks'] as num?)?.toDouble() ?? 0,
    );
  }
}
