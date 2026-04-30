import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class StudentAssignmentSubmissionBox extends StatefulWidget {
  final String homeworkId;

  const StudentAssignmentSubmissionBox({
    super.key,
    required this.homeworkId,
  });

  @override
  State<StudentAssignmentSubmissionBox> createState() =>
      _StudentAssignmentSubmissionBoxState();
}

class _StudentAssignmentSubmissionBoxState
    extends State<StudentAssignmentSubmissionBox> {
  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomPaint(
          painter: DashedRectPainter(
            color: AppColors.lightGrey,
            strokeWidth: 1.5,
            gap: 6.0,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _selectedFile != null
                        ? Icons.insert_drive_file
                        : Icons.cloud_upload_outlined,
                    color: AppColors.primaryColor,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedFile != null ? 'File Selected' : 'Upload Homework',
                  style: AppTextStyle.bold16.copyWith(
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedFile != null
                      ? _selectedFile!.name
                      : 'Drag and drop files or click to browse.\n(Max 20MB)',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.medium12.copyWith(
                    color: AppColors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _pickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _selectedFile != null ? 'Change File' : 'Select File',
                    style: AppTextStyle.bold14.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    var path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(16),
        ),
      );

    PathMetrics pathMetrics = path.computeMetrics();
    Path dashPath = Path();
    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2.5;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap;
  }
}
