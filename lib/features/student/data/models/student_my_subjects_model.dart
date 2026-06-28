import 'package:intl/intl.dart';

class StudentMySubjectDetail {
  final String subjectId;
  final String subjectName;
  final String? teacherName;
  final int lessonsCount;
  final int homeworksCount;
  final int examsCount;
  final double? averageGrade;
  final List<StudentMyLesson> lessons;
  final List<StudentMyHomework> homeworks;
  final List<StudentMyExam> exams;

  StudentMySubjectDetail({
    required this.subjectId,
    required this.subjectName,
    this.teacherName,
    required this.lessonsCount,
    required this.homeworksCount,
    required this.examsCount,
    this.averageGrade,
    required this.lessons,
    required this.homeworks,
    required this.exams,
  });

  factory StudentMySubjectDetail.fromJson(Map<String, dynamic> json) {
    return StudentMySubjectDetail(
      subjectId: json['subjectId']?.toString() ?? '',
      subjectName: json['subjectName']?.toString() ?? '',
      teacherName: json['teacherName']?.toString(),
      lessonsCount: (json['lessonsCount'] as num?)?.toInt() ?? 0,
      homeworksCount: (json['homeworksCount'] as num?)?.toInt() ?? 0,
      examsCount: (json['examsCount'] as num?)?.toInt() ?? 0,
      averageGrade: (json['averageGrade'] as num?)?.toDouble(),
      lessons: (json['lessons'] as List?)
              ?.whereType<Map>()
              .map((e) => StudentMyLesson.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      homeworks: (json['homeworks'] as List?)
              ?.whereType<Map>()
              .map((e) => StudentMyHomework.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      exams: (json['exams'] as List?)
              ?.whereType<Map>()
              .map((e) => StudentMyExam.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }
}

// ── Lesson ──────────────────────────────────────────────────────────────────

class StudentMyLesson {
  final String lessonId;
  final String title;
  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;
  final String status; // "Completed" | "Upcoming"
  final int materialsCount;

  StudentMyLesson({
    required this.lessonId,
    required this.title,
    this.date,
    this.startTime,
    this.endTime,
    required this.status,
    required this.materialsCount,
  });

  factory StudentMyLesson.fromJson(Map<String, dynamic> json) {
    return StudentMyLesson(
      lessonId: json['lessonId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      date: _tryParse(json['date']),
      startTime: _tryParse(json['startTime']),
      endTime: _tryParse(json['endTime']),
      status: json['status']?.toString() ?? '',
      materialsCount: (json['materialsCount'] as num?)?.toInt() ?? 0,
    );
  }

  bool get isCompleted => status.toLowerCase() == 'completed';

  String get formattedDate {
    if (date == null) return '';
    return DateFormat('MMM dd, yyyy').format(date!);
  }

  String get formattedTimeRange {
    if (startTime == null) return '';
    final start = DateFormat('hh:mm a').format(startTime!);
    if (endTime == null) return start;
    final end = DateFormat('hh:mm a').format(endTime!);
    return '$start – $end';
  }

  static DateTime? _tryParse(dynamic raw) {
    if (raw == null) return null;
    try {
      return DateTime.parse(raw.toString());
    } catch (_) {
      return null;
    }
  }
}

// ── Homework ─────────────────────────────────────────────────────────────────

class StudentMyHomework {
  final String homeworkId;
  final String title;
  final DateTime? dueDate;
  final int totalMarks;
  final String status; // "Pending" | "Submitted" | "Graded"
  final double? myGrade;
  final String? feedback;

  StudentMyHomework({
    required this.homeworkId,
    required this.title,
    this.dueDate,
    required this.totalMarks,
    required this.status,
    this.myGrade,
    this.feedback,
  });

  factory StudentMyHomework.fromJson(Map<String, dynamic> json) {
    return StudentMyHomework(
      homeworkId: json['homeworkId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      dueDate: _tryParse(json['dueDate']),
      totalMarks: (json['totalMarks'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? 'Pending',
      myGrade: (json['myGrade'] as num?)?.toDouble(),
      feedback: json['feedback']?.toString(),
    );
  }

  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  String get formattedDueDate {
    if (dueDate == null) return '';
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dueDate!);
  }

  static DateTime? _tryParse(dynamic raw) {
    if (raw == null) return null;
    try {
      return DateTime.parse(raw.toString());
    } catch (_) {
      return null;
    }
  }
}

// ── Exam ─────────────────────────────────────────────────────────────────────

class StudentMyExam {
  final String examId;
  final String name;
  final DateTime? date;
  final int maxScore;
  final String status;
  final double? myScore;

  StudentMyExam({
    required this.examId,
    required this.name,
    this.date,
    required this.maxScore,
    required this.status,
    this.myScore,
  });

  factory StudentMyExam.fromJson(Map<String, dynamic> json) {
    return StudentMyExam(
      examId: json['examId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      date: _tryParse(json['date']),
      maxScore: (json['maxScore'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? '',
      myScore: (json['myScore'] as num?)?.toDouble(),
    );
  }

  String get formattedDate {
    if (date == null) return '';
    return DateFormat('MMM dd, yyyy').format(date!);
  }

  static DateTime? _tryParse(dynamic raw) {
    if (raw == null) return null;
    try {
      return DateTime.parse(raw.toString());
    } catch (_) {
      return null;
    }
  }
}
