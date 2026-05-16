class ChildrenDashboardResponse {
  final bool success;
  final String? error;
  final ChildrenDashboardData? data;
  final String timestamp;

  ChildrenDashboardResponse({
    required this.success,
    this.error,
    this.data,
    required this.timestamp,
  });

  factory ChildrenDashboardResponse.fromJson(Map<String, dynamic> json) {
    return ChildrenDashboardResponse(
      success: json['success'] ?? false,
      error: json['messages']?['Error'],
      data: json['data'] != null ? ChildrenDashboardData.fromJson(json['data']) : null,
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class ChildrenDashboardData {
  final String parentName;
  final List<ChildDashboardItem> children;

  ChildrenDashboardData({
    required this.parentName,
    required this.children,
  });

  factory ChildrenDashboardData.fromJson(Map<String, dynamic> json) {
    return ChildrenDashboardData(
      parentName: json['parentName'] ?? '',
      children: (json['children'] as List? ?? [])
          .map((e) => ChildDashboardItem.fromJson(e))
          .toList(),
    );
  }
}

class ChildDashboardItem {
  final String studentOid;
  final String studentName;
  final String gradeLevel;
  final double gpa;
  final int attendance;
  final int subjectsCount;
  final SubjectPerformance subjectPerformance;
  final List<UpcomingEvent> upcomingEvents;
  final List<RecentActivity> recentActivities;

  ChildDashboardItem({
    required this.studentOid,
    required this.studentName,
    required this.gradeLevel,
    required this.gpa,
    required this.attendance,
    required this.subjectsCount,
    required this.subjectPerformance,
    required this.upcomingEvents,
    required this.recentActivities,
  });

  factory ChildDashboardItem.fromJson(Map<String, dynamic> json) {
    return ChildDashboardItem(
      studentOid: json['studentOid'] ?? '',
      studentName: json['studentName'] ?? '',
      gradeLevel: json['gradeLevel'] ?? '',
      gpa: (json['gpa'] as num? ?? 0).toDouble(),
      attendance: json['attendance'] ?? 0,
      subjectsCount: json['subjectsCount'] ?? 0,
      subjectPerformance: SubjectPerformance.fromJson(json['subjectPerformance'] ?? {}),
      upcomingEvents: (json['upcomingEvents'] as List? ?? [])
          .map((e) => UpcomingEvent.fromJson(e))
          .toList(),
      recentActivities: (json['recentActivities'] as List? ?? [])
          .map((e) => RecentActivity.fromJson(e))
          .toList(),
    );
  }
}

class SubjectPerformance {
  final List<SubjectScore> subjects;
  final String viewFullReportLink;

  SubjectPerformance({
    required this.subjects,
    required this.viewFullReportLink,
  });

  factory SubjectPerformance.fromJson(Map<String, dynamic> json) {
    return SubjectPerformance(
      subjects: (json['subjects'] as List? ?? [])
          .map((e) => SubjectScore.fromJson(e))
          .toList(),
      viewFullReportLink: json['viewFullReportLink'] ?? '',
    );
  }
}

class SubjectScore {
  final String name;
  final int percentage;

  SubjectScore({
    required this.name,
    required this.percentage,
  });

  factory SubjectScore.fromJson(Map<String, dynamic> json) {
    return SubjectScore(
      name: json['name'] ?? '',
      percentage: json['percentage'] ?? 0,
    );
  }
}

class UpcomingEvent {
  final String title;
  final String date;
  final String type;
  final String link;

  UpcomingEvent({
    required this.title,
    required this.date,
    required this.type,
    required this.link,
  });

  factory UpcomingEvent.fromJson(Map<String, dynamic> json) {
    return UpcomingEvent(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      type: json['type'] ?? '',
      link: json['link'] ?? '',
    );
  }
}

class RecentActivity {
  final String activity;
  final String timeAgo;
  final String status;

  RecentActivity({
    required this.activity,
    required this.timeAgo,
    required this.status,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      activity: json['activity'] ?? '',
      timeAgo: json['timeAgo'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
