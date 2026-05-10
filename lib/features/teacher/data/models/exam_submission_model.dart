// Just in case, but user provided specific model

class ExamSubmissionModel {
  final String submissionId;
  final String studentId;
  final String studentName;
  final String? answerText;
  final String? attachmentUrl;
  final String? fileName;
  final String submittedAt;
  final int score;
  final String? feedback;
  final String status; // "Pending" | "Graded"
  final String? gradedAt;
  final bool isGraded;

  ExamSubmissionModel({
    required this.submissionId,
    required this.studentId,
    required this.studentName,
    this.answerText,
    this.attachmentUrl,
    this.fileName,
    required this.submittedAt,
    required this.score,
    this.feedback,
    required this.status,
    this.gradedAt,
    required this.isGraded,
  });

  factory ExamSubmissionModel.fromJson(Map<String, dynamic> json) {
    return ExamSubmissionModel(
      submissionId: (json['submissionId'] ?? json['oid'] ?? json['id'] ?? '')
          .toString(),
      studentId: (json['studentId'] ?? json['studentOid'] ?? '').toString(),
      studentName: (json['studentName'] ?? '').toString(),
      answerText: json['answerText']?.toString() ?? json['content']?.toString(),
      attachmentUrl: json['attachmentUrl']?.toString(),
      fileName: json['fileName']?.toString(),
      submittedAt: (json['submittedAt'] ?? '').toString(),
      score: (json['score'] as num? ?? 0).toInt(),
      feedback: json['feedback']?.toString() ?? json['remarks']?.toString(),
      status:
          (json['status'] ?? (json['gradedAt'] != null ? 'Graded' : 'Pending'))
              .toString(),
      gradedAt: json['gradedAt']?.toString(),
      isGraded:
          json['isGraded'] as bool? ??
          (json['score'] != null ||
              json['status'] == 'Graded' ||
              json['gradedAt'] != null),
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
}

class ExamSubmissionsResponse {
  final int total;
  final int graded;
  final int pending;
  final List<ExamSubmissionModel> submissions;

  ExamSubmissionsResponse({
    required this.total,
    required this.graded,
    required this.pending,
    required this.submissions,
  });

  factory ExamSubmissionsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return ExamSubmissionsResponse(
      total: data['total'] as int? ?? 0,
      graded: data['graded'] as int? ?? 0,
      pending: data['pending'] as int? ?? 0,
      submissions: (data['submissions'] as List? ?? [])
          .map((e) => ExamSubmissionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
