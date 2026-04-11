import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class StudentExamSubmissionBox extends StatefulWidget {
  const StudentExamSubmissionBox({super.key});

  @override
  State<StudentExamSubmissionBox> createState() =>
      _StudentExamSubmissionBoxState();
}

class _StudentExamSubmissionBoxState extends State<StudentExamSubmissionBox> {
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
        Row(
          children: [
            Icon(Icons.folder_shared_outlined, color: AppColors.darkBlue),
            const SizedBox(width: 8),
            Text(
              'Your Submission',
              style: AppTextStyle.bold16.copyWith(color: AppColors.darkBlue),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _pickFile,
          child: CustomPaint(
            painter: _DashedRectPainter(
              color: AppColors.lightGrey,
              strokeWidth: 1.5,
              gap: 6.0,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.lightGrey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _selectedFile != null
                          ? Icons.insert_drive_file
                          : Icons.cloud_upload_outlined,
                      color: AppColors.secondaryColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _selectedFile != null ? 'File Selected' : 'Upload Answer Scripts',
                    style: AppTextStyle.bold14.copyWith(
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedFile != null
                        ? _selectedFile!.name
                        : 'Drag & drop or tap to browse',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.medium12.copyWith(
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                  ),
                  if (_selectedFile == null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'SUPPORTS PDF OR HIGH-QUALITY IMAGES',
                      style: AppTextStyle.bold12.copyWith(
                        color: AppColors.secondaryColor.withValues(alpha: 0.6),
                        fontSize: 9,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Warning Info Box
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xffF9F5FF), // Very light purple/grey tint from image
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xffF79009), // Orange warning color
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Ensure all pages are clearly visible and in correct order before submitting. You cannot edit after submission.',
                  style: AppTextStyle.medium12.copyWith(
                    color: AppColors.grey,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  _DashedRectPainter({
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
  bool shouldRepaint(covariant _DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap;
  }
}
