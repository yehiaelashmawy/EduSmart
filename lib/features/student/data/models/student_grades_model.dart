class StudentGradesDataModel {
  final String title;
  final String description;
  final OverallGPA? overallGPA;
  final GradeTrend? gradeTrend;
  final SubjectPerformance? subjectPerformance;
  final List<SubjectDetailedGrade> subjectDetailedGrades;
  final ClassRank? classRank;

  StudentGradesDataModel({
    required this.title,
    required this.description,
    this.overallGPA,
    this.gradeTrend,
    this.subjectPerformance,
    required this.subjectDetailedGrades,
    this.classRank,
  });

  factory StudentGradesDataModel.fromJson(Map<String, dynamic> json) {
    return StudentGradesDataModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      overallGPA: json['overallGPA'] != null
          ? OverallGPA.fromJson(json['overallGPA'])
          : null,
      gradeTrend: json['gradeTrend'] != null
          ? GradeTrend.fromJson(json['gradeTrend'])
          : null,
      subjectPerformance: json['subjectPerformance'] != null
          ? SubjectPerformance.fromJson(json['subjectPerformance'])
          : null,
      subjectDetailedGrades: (json['subjectDetailedGrades'] as List?)
              ?.map((e) => SubjectDetailedGrade.fromJson(e))
              .toList() ??
          [],
      classRank: json['classRank'] != null
          ? ClassRank.fromJson(json['classRank'])
          : null,
    );
  }
}

class OverallGPA {
  final double gpa;
  final num overallGrade;

  OverallGPA({required this.gpa, required this.overallGrade});

  factory OverallGPA.fromJson(Map<String, dynamic> json) {
    return OverallGPA(
      gpa: (json['gpa'] ?? 0).toDouble(),
      overallGrade: json['overallGrade'] ?? 0,
    );
  }
}

class GradeTrend {
  final List<String> months;
  final List<num> values;

  GradeTrend({required this.months, required this.values});

  factory GradeTrend.fromJson(Map<String, dynamic> json) {
    return GradeTrend(
      months: List<String>.from(json['months'] ?? []),
      values: List<num>.from(json['values'] ?? []),
    );
  }
}

class SubjectPerformance {
  final List<String> subjects;
  final List<num> grades;

  SubjectPerformance({required this.subjects, required this.grades});

  factory SubjectPerformance.fromJson(Map<String, dynamic> json) {
    return SubjectPerformance(
      subjects: List<String>.from(json['subjects'] ?? []),
      grades: List<num>.from(json['grades'] ?? []),
    );
  }
}

class SubjectDetailedGrade {
  final String subjectName;
  final String teacherName;
  final Components components;
  final List<Assessment> exams;
  final List<Assessment> assignments;

  SubjectDetailedGrade({
    required this.subjectName,
    required this.teacherName,
    required this.components,
    required this.exams,
    required this.assignments,
  });

  factory SubjectDetailedGrade.fromJson(Map<String, dynamic> json) {
    return SubjectDetailedGrade(
      subjectName: json['subjectName'] ?? '',
      teacherName: json['teacherName'] ?? '',
      components: Components.fromJson(json['components'] ?? {}),
      exams: (json['exams'] as List?)?.map((e) => Assessment.fromJson(e)).toList() ?? [],
      assignments: (json['assignments'] as List?)?.map((e) => Assessment.fromJson(e)).toList() ?? [],
    );
  }
}

class Components {
  final num exams;
  final num assignments;
  final num participation;
  final num attendance;

  Components({
    required this.exams,
    required this.assignments,
    required this.participation,
    required this.attendance,
  });

  factory Components.fromJson(Map<String, dynamic> json) {
    return Components(
      exams: json['exams'] ?? 0,
      assignments: json['assignments'] ?? 0,
      participation: json['participation'] ?? 0,
      attendance: json['attendance'] ?? 0,
    );
  }
}

class Assessment {
  final String title;
  final String dueDate;
  final num grade;
  final num totalMarks;
  final num percentage;

  Assessment({
    required this.title,
    required this.dueDate,
    required this.grade,
    required this.totalMarks,
    required this.percentage,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      title: json['title'] ?? '',
      dueDate: json['dueDate'] ?? '',
      grade: json['grade'] ?? 0,
      totalMarks: json['totalMarks'] ?? 0,
      percentage: json['percentage'] ?? 0,
    );
  }
}

class ClassRank {
  final int rank;
  final int totalStudents;
  final String text;

  ClassRank({
    required this.rank,
    required this.totalStudents,
    required this.text,
  });

  factory ClassRank.fromJson(Map<String, dynamic> json) {
    return ClassRank(
      rank: json['rank'] ?? 0,
      totalStudents: json['totalStudents'] ?? 0,
      text: json['text'] ?? '',
    );
  }
}
