class ParentGradesModel {
  final String studentOid;
  final String studentName;
  final GradeSummaryModel summary;
  final List<GradeTrendModel> gradeTrend;
  final List<SubjectPerformanceModel> subjectPerformance;

  ParentGradesModel({
    required this.studentOid,
    required this.studentName,
    required this.summary,
    required this.gradeTrend,
    required this.subjectPerformance,
  });

  factory ParentGradesModel.fromJson(Map<String, dynamic> json) {
    return ParentGradesModel(
      studentOid: json['studentOid'] ?? '',
      studentName: json['studentName'] ?? '',
      summary: GradeSummaryModel.fromJson(json['summary'] ?? {}),
      gradeTrend: (json['gradeTrend'] as List? ?? [])
          .map((e) => GradeTrendModel.fromJson(e))
          .toList(),
      subjectPerformance: (json['subjectPerformance'] as List? ?? [])
          .map((e) => SubjectPerformanceModel.fromJson(e))
          .toList(),
    );
  }
}

class GradeSummaryModel {
  final double gpa;
  final double overallGrade;
  final String letterGrade;
  final int classRank;
  final int totalStudentsInClass;

  GradeSummaryModel({
    required this.gpa,
    required this.overallGrade,
    required this.letterGrade,
    required this.classRank,
    required this.totalStudentsInClass,
  });

  factory GradeSummaryModel.fromJson(Map<String, dynamic> json) {
    return GradeSummaryModel(
      gpa: (json['gpa'] as num?)?.toDouble() ?? 0,
      overallGrade: (json['overallGrade'] as num?)?.toDouble() ?? 0,
      letterGrade: json['letterGrade'] ?? '',
      classRank: json['classRank'] ?? 0,
      totalStudentsInClass: json['totalStudentsInClass'] ?? 0,
    );
  }
}

class GradeTrendModel {
  final String month;
  final double averageScore;

  GradeTrendModel({required this.month, required this.averageScore});

  factory GradeTrendModel.fromJson(Map<String, dynamic> json) {
    return GradeTrendModel(
      month: json['month'] ?? '',
      averageScore: (json['averageScore'] as num?)?.toDouble() ?? 0,
    );
  }
}

class SubjectPerformanceModel {
  final String subjectName;
  final double subjectAverage;
  final String letterGrade;
  final List<ExamGradeModel> exams;
  final List<AssignmentGradeModel> assignments;

  SubjectPerformanceModel({
    required this.subjectName,
    required this.subjectAverage,
    required this.letterGrade,
    required this.exams,
    required this.assignments,
  });

  factory SubjectPerformanceModel.fromJson(Map<String, dynamic> json) {
    return SubjectPerformanceModel(
      subjectName: json['subjectName'] ?? '',
      subjectAverage: (json['subjectAverage'] as num?)?.toDouble() ?? 0,
      letterGrade: json['letterGrade'] ?? '',
      exams: (json['exams'] as List? ?? [])
          .map((e) => ExamGradeModel.fromJson(e))
          .toList(),
      assignments: (json['assignments'] as List? ?? [])
          .map((e) => AssignmentGradeModel.fromJson(e))
          .toList(),
    );
  }
}

class ExamGradeModel {
  final String examName;
  final double score;
  final double maxScore;

  ExamGradeModel({
    required this.examName,
    required this.score,
    required this.maxScore,
  });

  factory ExamGradeModel.fromJson(Map<String, dynamic> json) {
    return ExamGradeModel(
      examName: json['examName'] ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0,
      maxScore: (json['maxScore'] as num?)?.toDouble() ?? 100,
    );
  }
}

class AssignmentGradeModel {
  final String assignmentName;
  final double score;
  final double maxScore;

  AssignmentGradeModel({
    required this.assignmentName,
    required this.score,
    required this.maxScore,
  });

  factory AssignmentGradeModel.fromJson(Map<String, dynamic> json) {
    return AssignmentGradeModel(
      assignmentName: json['assignmentName'] ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0,
      maxScore: (json['maxScore'] as num?)?.toDouble() ?? 100,
    );
  }
}
