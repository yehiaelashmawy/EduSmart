import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/custom_dropdown_field.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/custom_text_field.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/dashed_upload_button.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/field_label.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/lesson_file_card.dart';

class AddNewLessonViewBody extends StatefulWidget {
  const AddNewLessonViewBody({super.key});

  @override
  State<AddNewLessonViewBody> createState() => _AddNewLessonViewBodyState();
}

class _AddNewLessonViewBodyState extends State<AddNewLessonViewBody> {
  final List<PlatformFile> _attachedFiles = [];

  String? _selectedSubject;
  String? _selectedClass;

  final List<String> _subjects = [
    'Mathematics',
    'Science',
    'Physics',
    'Chemistry',
    'English',
    'History',
  ];

  final List<String> _classes = [
    'Class 10A',
    'Class 10B',
    'Class 11A',
    'Class 11B',
    'Class 12A',
    'Class 12B',
  ];

  Future<void> _pickPDFs() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _attachedFiles.addAll(result.files);
      });
    }
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _attachedFiles.addAll(result.files);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel(label: 'Lesson Title'),
          const SizedBox(height: 8),
          const CustomTextField(
            hintText: 'e.g., Introduction to Quadratic Equations',
          ),

          const SizedBox(height: 20),

          const FieldLabel(label: 'Subject'),
          const SizedBox(height: 8),
          CustomDropdownField(
            hintText: 'Mathematics',
            items: _subjects,
            value: _selectedSubject,
            onChanged: (val) {
              setState(() {
                _selectedSubject = val;
              });
            },
          ),

          const SizedBox(height: 20),

          const FieldLabel(label: 'Class/Section'),
          const SizedBox(height: 8),
          CustomDropdownField(
            hintText: 'Select Class',
            items: _classes,
            value: _selectedClass,
            onChanged: (val) {
              setState(() {
                _selectedClass = val;
              });
            },
          ),

          const SizedBox(height: 20),

          const FieldLabel(label: 'Scheduled Date & Time'),
          const SizedBox(height: 8),
          const CustomTextField(hintText: 'mm/dd/yyyy, --:-- --'),

          const SizedBox(height: 20),

          const FieldLabel(label: 'Lesson Description/Objectives'),
          const SizedBox(height: 8),
          const CustomTextField(
            hintText: 'What will the students learn today?',
            maxLines: 4,
          ),

          const SizedBox(height: 20),

          const FieldLabel(label: 'Attachments'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DashedUploadButton(
                  title: 'Upload PDF',
                  icon: Icons.picture_as_pdf_outlined,
                  onTap: _pickPDFs,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DashedUploadButton(
                  title: 'Add Images',
                  icon: Icons.image_outlined,
                  onTap: _pickImages,
                ),
              ),
            ],
          ),

          if (_attachedFiles.isNotEmpty) ...[
            const SizedBox(height: 16),
            ..._attachedFiles.map((file) {
              final isPdf = file.extension?.toLowerCase() == 'pdf';
              final kbSize = file.size / 1024;
              final mbSize = kbSize / 1024;
              final sizeStr = mbSize > 1
                  ? '${mbSize.toStringAsFixed(1)} MB'
                  : '${kbSize.toStringAsFixed(0)} KB';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: LessonFileCard(
                  fileName: file.name,
                  fileInfo: '$sizeStr • ${isPdf ? 'PDF Document' : 'Image'}',
                  iconColor: isPdf
                      ? const Color(0xffFEE2E2)
                      : const Color(0xffDBEAFE),
                  iconData: isPdf ? Icons.picture_as_pdf : Icons.image,
                  iconWidgetColor: isPdf
                      ? const Color(0xffDC2626)
                      : const Color(0xff2563EB),
                ),
              );
            }),
          ],

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload, color: Colors.white, size: 20),
              label: const Text(
                'Publish Lesson',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
