import 'package:flutter/material.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/data/repos/teacher_classes_repo.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/exams_list_body.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/homework_list_body.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/lessons_list_body.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/students_list_body.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/attendance_list_body.dart';
import 'package:school_system/features/teacher/presentation/views/add_homework_view.dart';

import '../../data/models/teacher_exam_model.dart';

class StudentList extends StatefulWidget {
  final String className;
  final TeacherClassModel? teacherClass;
  const StudentList({
    super.key,
    this.className = 'Grade 10-A - Mathematics',
    this.teacherClass,
  });
  static const String routeName = '/student_list';

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late TeacherClassModel? _currentClass;
  bool _hasDataChanges = false;
  final Set<String> _deletedLessonIds = <String>{};
  static const int _lessonsTabIndex = 1;
  static const int _homeworkTabIndex = 2;
  static const int _examsTabIndex = 3;

  bool get _isLessonsTab => _tabController.index == _lessonsTabIndex;
  bool get _isExamsTab => _tabController.index == _examsTabIndex;
  bool get _isHomeworkTab => _tabController.index == _homeworkTabIndex;

  List<TeacherLessonModel> get _classLessons {
    final students = _currentClass?.students ?? const <TeacherStudentModel>[];
    final map = <String, TeacherLessonModel>{};
    for (final student in students) {
      for (final lesson in student.details.lessons) {
        final key = lesson.oid.isNotEmpty
            ? lesson.oid
            : '${lesson.title}-${lesson.date}';
        map.putIfAbsent(key, () => lesson);
      }
    }
    final lessons = map.values.toList();
    lessons.removeWhere((lesson) => _deletedLessonIds.contains(lesson.oid));
    lessons.sort((a, b) {
      final aDate = DateTime.tryParse(a.date);
      final bDate = DateTime.tryParse(b.date);
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });
    return lessons;
  }

  List<TeacherHomeworkModel> get _classHomeworks {
    final students = _currentClass?.students ?? const <TeacherStudentModel>[];
    final map = <String, TeacherHomeworkModel>{};
    for (final student in students) {
      for (final homework in student.details.homeworks) {
        final key = homework.oid.isNotEmpty
            ? homework.oid
            : '${homework.title}-${homework.dueDate}';
        map.putIfAbsent(key, () => homework);
      }
    }
    final homeworks = map.values.toList();
    homeworks.sort((a, b) {
      final aDate = DateTime.tryParse(a.dueDate);
      final bDate = DateTime.tryParse(b.dueDate);
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return aDate.compareTo(bDate);
    });
    return homeworks;
  }

  List<TeacherExamModel> get _classExams {
    final students = _currentClass?.students ?? const <TeacherStudentModel>[];
    final map = <String, TeacherExamModel>{};
    for (final student in students) {
      for (final exam in student.details.exams) {
        final key = exam.oid.isNotEmpty
            ? exam.oid
            : '${exam.name}-${exam.date}';
        map.putIfAbsent(key, () => exam);
      }
    }
    final exams = map.values.toList();
    exams.sort((a, b) {
      final aDate = DateTime.tryParse(a.date);
      final bDate = DateTime.tryParse(b.date);
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return aDate.compareTo(bDate);
    });
    return exams;
  }

  TeacherAttendanceModel get _classAttendance {
    final students = _currentClass?.students ?? const <TeacherStudentModel>[];
    int present = 0;
    int absent = 0;
    int late = 0;
    double percentSum = 0;
    int percentCount = 0;

    for (final student in students) {
      final attendance = student.details.attendance;
      present += attendance.presentCount;
      absent += attendance.absentCount;
      late += attendance.lateCount;
      percentSum += attendance.attendancePercentage;
      percentCount += 1;
    }

    final avgPercent = percentCount == 0
        ? 0.0
        : (percentSum / percentCount).toDouble();
    return TeacherAttendanceModel(
      presentCount: present,
      absentCount: absent,
      lateCount: late,
      attendancePercentage: avgPercent,
    );
  }

  Color get _attendanceStatusColor {
    final pct = _classAttendance.attendancePercentage;
    if (pct >= 80) return AppColors.secondaryColor;
    if (pct >= 60) return AppColors.primaryColor;
    return Colors.red;
  }

  String get _attendanceStatusText {
    return 'AVG ATTENDANCE: ${_classAttendance.attendancePercentage.toStringAsFixed(1)}%';
  }

  /// Merges [details.attendance.recentRecords] from every student (same API payload).
  List<TeacherAttendanceListEntry> get _attendanceRecentEntries {
    final students = _currentClass?.students ?? const <TeacherStudentModel>[];
    final entries = <TeacherAttendanceListEntry>[];
    for (final student in students) {
      for (final record in student.details.attendance.recentRecords) {
        entries.add(
          TeacherAttendanceListEntry(
            studentName: student.fullName.trim().isNotEmpty
                ? student.fullName
                : 'Student',
            record: record,
          ),
        );
      }
    }
    entries.sort((a, b) {
      final da = DateTime.tryParse(a.record.date);
      final db = DateTime.tryParse(b.record.date);
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return db.compareTo(da);
    });
    return entries;
  }

  Future<void> _refreshClassData() async {
    final classOid = _currentClass?.oid;
    if (classOid == null || classOid.isEmpty) return;

    final result = await TeacherClassesRepo(ApiService()).getTeacherClasses();
    result.fold((_) {}, (classes) {
      final updated = classes.where((c) => c.oid == classOid).toList();
      if (updated.isNotEmpty && mounted) {
        setState(() {
          _currentClass = updated.first;
        });
      }
    });
  }

  Future<void> _openAddLesson() async {
    final created = await Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/add_new_lesson');
    if (created == true) {
      _hasDataChanges = true;
      await _refreshClassData();
    }
  }

  void _handleLessonDeleted(String lessonId) {
    if (lessonId.trim().isEmpty) return;
    setState(() {
      _deletedLessonIds.add(lessonId);
      _hasDataChanges = true;
    });
  }

  void _handleExamDeleted(String examId) {
    if (examId.trim().isEmpty) return;
    setState(() {
      _hasDataChanges = true;
    });
    _refreshClassData();
  }

  Future<void> _openAddExam() async {
    final created = await Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/add_new_exam');
    if (created == true) {
      _hasDataChanges = true;
      await _refreshClassData();
    }
  }

  Future<void> _openAddHomework() async {
    final created = await Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AddHomeworkView.routeName);
    if (created == true) {
      _hasDataChanges = true;
      await _refreshClassData();
      if (mounted) {
        setState(() {
          _tabController.index = _homeworkTabIndex;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _currentClass = widget.teacherClass;
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context, _hasDataChanges),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentClass?.name ?? widget.className,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Academic Year 2023/24',
              style: TextStyle(color: AppColors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.black),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.primaryColor,
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          indicatorWeight: 3,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'Students'),
            Tab(text: 'Lessons'),
            Tab(text: 'Homework'),
            Tab(text: 'Exams'),
            Tab(text: 'Attendance'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          StudentsListBody(students: _currentClass?.students ?? const []),
          LessonsListBody(
            lessons: _classLessons,
            onLessonDeleted: _handleLessonDeleted,
          ),
          HomeworkListBody(
            homeworks: _classHomeworks,
            classStudents: _currentClass?.students ?? const [],
          ),
          ExamsListBody(
            exams: _classExams,
            onExamDeleted: _handleExamDeleted,
          ),
          AttendanceListBody(
            teacherClass: _currentClass,
            className: _currentClass?.name ?? widget.className,
            studentCount: _currentClass?.studentsCount ?? 0,
            summary: _classAttendance,
            statusColor: _attendanceStatusColor,
            statusText: _attendanceStatusText,
            recentEntries: _attendanceRecentEntries,
          ),
        ],
      ),
      floatingActionButton: AnimatedScale(
        scale: (_isExamsTab || _isHomeworkTab || _isLessonsTab) ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: FloatingActionButton(
          onPressed: _isExamsTab
              ? _openAddExam
              : (_isHomeworkTab
                    ? _openAddHomework
                    : (_isLessonsTab ? _openAddLesson : null)),
          backgroundColor: AppColors.secondaryColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            _isHomeworkTab
                ? Icons.assignment_add
                : (_isLessonsTab ? Icons.library_add : Icons.add),
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
