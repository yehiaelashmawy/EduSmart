class StudentAttendanceSubmitModel {
  final bool success;
  final String status;
  final String checkInTime;
  final String message;

  StudentAttendanceSubmitModel({
    required this.success,
    required this.status,
    required this.checkInTime,
    required this.message,
  });

  factory StudentAttendanceSubmitModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return StudentAttendanceSubmitModel(
      success: data['success'] as bool? ?? false,
      status: data['status'] as String? ?? 'NotRecorded',
      checkInTime: data['checkInTime'] as String? ?? '',
      message: data['message'] as String? ?? '',
    );
  }
}
