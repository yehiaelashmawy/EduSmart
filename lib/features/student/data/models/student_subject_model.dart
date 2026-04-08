class StudentSubjectModel {
  final String trackName;
  final String subjectName;
  final String professorName;
  final int progressPercentage;
  final int attendancePercentage;
  final int assignmentsPercentage;

  StudentSubjectModel({
    required this.trackName,
    required this.subjectName,
    required this.professorName,
    required this.progressPercentage,
    required this.attendancePercentage,
    required this.assignmentsPercentage,
  });
}
