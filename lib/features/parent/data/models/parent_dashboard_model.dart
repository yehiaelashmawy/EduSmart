class ParentDashboardModel {
  final List<ParentChildModel> children;
  final SubjectPerformanceModel? subjectPerformance;
  final List<UpcomingEventModel> upcomingEvents;
  final List<RecentActivityModel> recentActivities;

  ParentDashboardModel({
    required this.children,
    this.subjectPerformance,
    required this.upcomingEvents,
    required this.recentActivities,
  });

  factory ParentDashboardModel.fromJson(Map<String, dynamic> json) {
    return ParentDashboardModel(
      children: json['children'] != null
          ? (json['children'] as List)
                .map((e) => ParentChildModel.fromJson(e))
                .toList()
          : [],
      subjectPerformance: json['subjectPerformance'] != null
          ? SubjectPerformanceModel.fromJson(json['subjectPerformance'])
          : null,
      upcomingEvents: json['upcomingEvents'] != null
          ? (json['upcomingEvents'] as List)
                .map((e) => UpcomingEventModel.fromJson(e))
                .toList()
          : [],
      recentActivities: json['recentActivities'] != null
          ? (json['recentActivities'] as List)
                .map((e) => RecentActivityModel.fromJson(e))
                .toList()
          : [],
    );
  }
}

class ParentChildModel {
  final String childId;
  final String name;
  final String gradeLevel;
  final double gpa;
  final double attendance;
  final int subjectsCount;

  ParentChildModel({
    required this.childId,
    required this.name,
    required this.gradeLevel,
    required this.gpa,
    required this.attendance,
    required this.subjectsCount,
  });

  factory ParentChildModel.fromJson(Map<String, dynamic> json) {
    return ParentChildModel(
      childId: json['childId'] ?? json['studentOid'] ?? '',
      name: json['name'] ?? json['studentName'] ?? '',
      gradeLevel: json['gradeLevel'] ?? '',
      gpa: (json['gpa'] as num?)?.toDouble() ?? 0,
      attendance: (json['attendance'] as num?)?.toDouble() ?? 0,
      subjectsCount: json['subjectsCount'] ?? 0,
    );
  }
}

class SubjectPerformanceModel {
  final List<SubjectModel> subjects;
  final String? viewFullReportLink;

  SubjectPerformanceModel({required this.subjects, this.viewFullReportLink});

  factory SubjectPerformanceModel.fromJson(Map<String, dynamic> json) {
    return SubjectPerformanceModel(
      subjects: json['subjects'] != null
          ? (json['subjects'] as List)
                .map((e) => SubjectModel.fromJson(e))
                .toList()
          : [],
      viewFullReportLink: json['viewFullReportLink'],
    );
  }
}

class SubjectModel {
  final String name;
  final double percentage;

  SubjectModel({required this.name, required this.percentage});

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      name: json['name'] ?? '',
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
    );
  }
}

class UpcomingEventModel {
  final String title;
  final String date;
  final String type;
  final String link;

  UpcomingEventModel({
    required this.title,
    required this.date,
    required this.type,
    required this.link,
  });

  factory UpcomingEventModel.fromJson(Map<String, dynamic> json) {
    return UpcomingEventModel(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      type: json['type'] ?? '',
      link: json['link'] ?? '',
    );
  }
}

class RecentActivityModel {
  final String activity;
  final String timeAgo;
  final String status;

  RecentActivityModel({
    required this.activity,
    required this.timeAgo,
    required this.status,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      activity: json['activity'] ?? '',
      timeAgo: json['timeAgo'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
