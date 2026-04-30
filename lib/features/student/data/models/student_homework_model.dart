class StudentHomeworkDataModel {
  final String? title;
  final String? subtitle;
  final StudentHomeworkStatsModel? stats;
  final List<StudentHomeworkItemModel>? homeworks;

  StudentHomeworkDataModel({
    this.title,
    this.subtitle,
    this.stats,
    this.homeworks,
  });

  factory StudentHomeworkDataModel.fromJson(Map<String, dynamic> json) {
    return StudentHomeworkDataModel(
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      stats: json['stats'] != null
          ? StudentHomeworkStatsModel.fromJson(json['stats'])
          : null,
      homeworks: json['homeworks'] != null
          ? (json['homeworks'] as List)
              .map((e) => StudentHomeworkItemModel.fromJson(e))
              .toList()
          : null,
    );
  }
}

class StudentHomeworkStatsModel {
  final int? pending;
  final int? submitted;
  final int? graded;

  StudentHomeworkStatsModel({
    this.pending,
    this.submitted,
    this.graded,
  });

  factory StudentHomeworkStatsModel.fromJson(Map<String, dynamic> json) {
    return StudentHomeworkStatsModel(
      pending: json['pending'] as int?,
      submitted: json['submitted'] as int?,
      graded: json['graded'] as int?,
    );
  }
}

class StudentHomeworkItemModel {
  final String? homeworkId;
  final String? title;
  final String? subjectName;
  final String? teacherName;
  final String? description;
  final String? dueDate;
  final bool? isOverdue;
  final String? status;
  final num? grade;
  final num? totalMarks;
  final String? priority;
  final String? attachmentUrl;
  final List<StudentHomeworkMaterialModel>? materials;

  StudentHomeworkItemModel({
    this.homeworkId,
    this.title,
    this.subjectName,
    this.teacherName,
    this.description,
    this.dueDate,
    this.isOverdue,
    this.status,
    this.grade,
    this.totalMarks,
    this.priority,
    this.attachmentUrl,
    this.materials,
  });

  factory StudentHomeworkItemModel.fromJson(Map<String, dynamic> json) {
    return StudentHomeworkItemModel(
      homeworkId: json['homeworkId'] as String?,
      title: json['title'] as String?,
      subjectName: json['subjectName'] as String?,
      teacherName: json['teacherName'] as String?,
      description: json['description'] as String?,
      dueDate: json['dueDate'] as String?,
      isOverdue: json['isOverdue'] as bool?,
      status: json['status'] as String?,
      grade: json['grade'] as num?,
      totalMarks: json['totalMarks'] as num?,
      priority: json['priority'] as String?,
      attachmentUrl: json['attachmentUrl'] as String?,
      materials: json['materials'] != null
          ? (json['materials'] as List)
              .map((e) => StudentHomeworkMaterialModel.fromJson(e))
              .toList()
          : null,
    );
  }
}

class StudentHomeworkMaterialModel {
  final String? fileName;
  final String? fileUrl;
  final String? fileType;
  final num? fileSize;
  final String? sizeText;

  StudentHomeworkMaterialModel({
    this.fileName,
    this.fileUrl,
    this.fileType,
    this.fileSize,
    this.sizeText,
  });

  factory StudentHomeworkMaterialModel.fromJson(Map<String, dynamic> json) {
    return StudentHomeworkMaterialModel(
      fileName: json['fileName'] as String?,
      fileUrl: json['fileUrl'] as String?,
      fileType: json['fileType'] as String?,
      fileSize: json['fileSize'] as num?,
      sizeText: json['sizeText'] as String?,
    );
  }
}
