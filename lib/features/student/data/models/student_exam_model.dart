class StudentExamModel {
  final String? examId;
  final String? name;
  final String? description;
  final String? type;
  final String? subjectName;
  final String? teacherName;
  final String? instructions;
  final String? date;
  final String? startTime;
  final String? duration;
  final int? maxScore;
  final int? passingScore;
  final String? status;
  final String? room;
  final List<ExamMaterialModel>? materials;
  final MyExamSubmissionModel? mySubmission;

  StudentExamModel({
    this.examId,
    this.name,
    this.description,
    this.type,
    this.subjectName,
    this.teacherName,
    this.instructions,
    this.date,
    this.startTime,
    this.duration,
    this.maxScore,
    this.passingScore,
    this.status,
    this.room,
    this.materials,
    this.mySubmission,
  });

  factory StudentExamModel.fromJson(Map<String, dynamic> json) {
    return StudentExamModel(
      examId: json['examId'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      subjectName: json['subjectName'],
      teacherName: json['teacherName'],
      instructions: json['instructions'],
      date: json['date'],
      startTime: json['startTime'],
      duration: json['duration'],
      maxScore: json['maxScore'],
      passingScore: json['passingScore'],
      status: json['status'],
      room: json['room'],
      materials: (json['materials'] as List?)
          ?.map((e) => ExamMaterialModel.fromJson(e))
          .toList(),
      mySubmission: json['mySubmission'] != null
          ? MyExamSubmissionModel.fromJson(json['mySubmission'])
          : null,
    );
  }
}

class ExamMaterialModel {
  final String? name;
  final String? fileUrl;
  final String? fileType;
  final int? fileSize;

  ExamMaterialModel({this.name, this.fileUrl, this.fileType, this.fileSize});

  factory ExamMaterialModel.fromJson(Map<String, dynamic> json) {
    return ExamMaterialModel(
      name: json['name'],
      fileUrl: json['fileUrl'],
      fileType: json['fileType'],
      fileSize: json['fileSize'],
    );
  }
}

class MyExamSubmissionModel {
  final String? submissionId;
  final String? answerText;
  final String? attachmentUrl;
  final String? fileName;
  final String? submittedAt;
  final double? score;
  final String? feedback;
  final String? status;
  final String? gradedAt;
  final bool? isGraded;

  MyExamSubmissionModel({
    this.submissionId,
    this.answerText,
    this.attachmentUrl,
    this.fileName,
    this.submittedAt,
    this.score,
    this.feedback,
    this.status,
    this.gradedAt,
    this.isGraded,
  });

  factory MyExamSubmissionModel.fromJson(Map<String, dynamic> json) {
    return MyExamSubmissionModel(
      submissionId: json['submissionId'],
      answerText: json['answerText'],
      attachmentUrl: json['attachmentUrl'],
      fileName: json['fileName'],
      submittedAt: json['submittedAt'],
      score: json['score']?.toDouble(),
      feedback: json['feedback'],
      status: json['status'],
      gradedAt: json['gradedAt'],
      isGraded: json['isGraded'],
    );
  }
}

class StudentExamsResponse {
  final bool success;
  final List<StudentExamModel> exams;

  StudentExamsResponse({required this.success, required this.exams});

  factory StudentExamsResponse.fromJson(Map<String, dynamic> json) {
    return StudentExamsResponse(
      success: json['success'] ?? false,
      exams: (json['data'] as List?)
              ?.map((e) => StudentExamModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
