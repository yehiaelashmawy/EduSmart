import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:school_system/features/student/presentation/manager/student_exams_cubit/student_exams_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_submit_exam_cubit/student_submit_exam_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_submit_exam_cubit/student_submit_exam_state.dart';

class StudentExamSubmissionBox extends StatefulWidget {
  final String examId;

  const StudentExamSubmissionBox({super.key, required this.examId});

  @override
  State<StudentExamSubmissionBox> createState() =>
      _StudentExamSubmissionBoxState();
}

class _StudentExamSubmissionBoxState extends State<StudentExamSubmissionBox> {
  File? _selectedFile;
  String? _fileName;
  int? _fileSize;
  bool _isImage = false;

  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
        _fileSize = result.files.single.size;
        _isImage = [
          'jpg',
          'jpeg',
          'png',
          'gif',
        ].contains(_fileName!.split('.').last.toLowerCase());
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      final file = File(image.path);
      final size = await file.length();
      setState(() {
        _selectedFile = file;
        _fileName = image.name;
        _fileSize = size;
        _isImage = true;
      });
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Submission Method',
              style: AppTextStyle.bold16.copyWith(color: AppColors.darkBlue),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _PickerOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                _PickerOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                _PickerOption(
                  icon: Icons.folder_open_rounded,
                  label: 'Files',
                  onTap: () {
                    Navigator.pop(context);
                    _pickFile();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _removeFile() {
    setState(() {
      _selectedFile = null;
      _fileName = null;
      _fileSize = null;
      _isImage = false;
    });
  }

  void _submit() {
    if (_selectedFile == null && _textController.text.trim().isEmpty) {
      CustomSnackBar.showError(context, 'Please select a file or enter text.');
      return;
    }

    context.read<StudentSubmitExamCubit>().submit(
          examId: widget.examId,
          file: _selectedFile,
          answerText: _textController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentSubmitExamCubit, StudentSubmitExamState>(
      listener: (context, state) {
        if (state is StudentSubmitExamSuccess) {
          CustomSnackBar.showSuccess(context, 'Exam submitted successfully!');
          try {
            context.read<StudentExamsCubit>().fetchExams();
          } catch (e) {}
          Navigator.pop(context);
        } else if (state is StudentSubmitExamFailure) {
          CustomSnackBar.showError(context, state.error.errorMessage);
        }
      },
      builder: (context, state) {
        final bool isLoading = state is StudentSubmitExamLoading;

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
            if (_selectedFile == null)
              GestureDetector(
                onTap: isLoading ? null : _showPickerOptions,
                child: CustomPaint(
                  painter: _DashedRectPainter(
                    color: AppColors.primaryColor.withValues(alpha: 0.3),
                    strokeWidth: 1.5,
                    gap: 8.0,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.02),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.08,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            color: AppColors.primaryColor,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Upload Answer Scripts',
                          style: AppTextStyle.bold16.copyWith(
                            color: AppColors.darkBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Take a photo, select from gallery\nor upload a document.',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.medium12.copyWith(
                            color: AppColors.grey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              _SelectedFileCard(
                fileName: _fileName ?? 'Unknown',
                fileSize: _fileSize ?? 0,
                file: _selectedFile!,
                isImage: _isImage,
                onRemove: isLoading ? null : _removeFile,
              ),
            const SizedBox(height: 24),
            Text(
              'Submission Notes',
              style: AppTextStyle.bold14.copyWith(color: AppColors.darkBlue),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _textController,
              maxLines: 4,
              enabled: !isLoading,
              decoration: InputDecoration(
                hintText: 'Enter your answer or notes here...',
                hintStyle: AppTextStyle.medium12.copyWith(
                  color: AppColors.grey.withValues(alpha: 0.6),
                ),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.lightGrey.withValues(alpha: 0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.lightGrey.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: isLoading
                      ? [AppColors.grey, AppColors.grey.withValues(alpha: 0.7)]
                      : [const Color(0xff0F52BD), AppColors.primaryColor],
                ),
                boxShadow: [
                  if (!isLoading)
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Submit Exam',
                            style: AppTextStyle.bold16.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.send_rounded,
                              color: Colors.white, size: 20),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            // Warning Info Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xffF9F5FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xffF79009),
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
      },
    );
  }
}

class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyle.medium12.copyWith(color: AppColors.darkBlue),
          ),
        ],
      ),
    );
  }
}

class _SelectedFileCard extends StatelessWidget {
  final String fileName;
  final int fileSize;
  final File file;
  final bool isImage;
  final VoidCallback? onRemove;

  const _SelectedFileCard({
    required this.fileName,
    required this.fileSize,
    required this.file,
    required this.isImage,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isImage
                ? Image.file(file, width: 56, height: 56, fit: BoxFit.cover)
                : Container(
                    width: 56,
                    height: 56,
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.insert_drive_file_rounded,
                      color: AppColors.primaryColor,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: AppTextStyle.bold14.copyWith(
                    color: AppColors.darkBlue,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB',
                  style: AppTextStyle.medium12.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.cancel_rounded, color: Color(0xffF04438)),
          ),
        ],
      ),
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
