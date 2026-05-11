class SubmissionModel {
  final String id;
  final String studentName;
  final String studentEmail;
  final String content;
  final String? attachmentUrl;
  final String submittedAt;
  final double? grade;
  final double? totalMarks;
  final String? feedback;
  final String status;
  final bool isLate;

  const SubmissionModel({
    required this.id,
    required this.studentName,
    required this.studentEmail,
    required this.content,
    this.attachmentUrl,
    required this.submittedAt,
    this.grade,
    this.totalMarks,
    this.feedback,
    required this.status,
    required this.isLate,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: (json['submissionId'] ?? json['id'] ?? '').toString(),
      studentName: (json['studentName'] ?? '').toString(),
      studentEmail: (json['studentEmail'] ?? json['studentId'] ?? '').toString(),
      content: (json['answerText'] ?? json['content'] ?? '').toString(),
      attachmentUrl: json['attachmentUrl']?.toString(),
      submittedAt: (json['submittedAt'] ?? '').toString(),
      grade: (json['score'] as num? ?? json['grade'] as num?)?.toDouble(),
      totalMarks: (json['totalMarks'] as num? ?? json['maxScore'] as num? ?? json['maxGrade'] as num?)?.toDouble(),
      feedback: json['feedback']?.toString(),
      status: (json['status'] ?? '').toString(),
      isLate: json['isLate'] as bool? ?? false,
    );
  }

  String get initials {
    final parts = studentName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    }
    final a = parts.first[0];
    final b = parts.last[0];
    return (a + b).toUpperCase();
  }

  bool get isGraded => grade != null;
}
