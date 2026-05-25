import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:school_system/features/teacher/presentation/manager/add_lesson_cubit/add_lesson_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/add_lesson_cubit/add_lesson_state.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_classes_cubit/teacher_classes_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_classes_cubit/teacher_classes_state.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_subjects_cubit/teacher_subjects_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_subjects_cubit/teacher_subjects_state.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/custom_dropdown_field.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/custom_text_field.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/dashed_upload_button.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/field_label.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/lesson_file_card.dart';
import 'package:school_system/core/helper/localization_helper.dart';

class AddNewLessonViewBody extends StatefulWidget {
  const AddNewLessonViewBody({super.key});

  @override
  State<AddNewLessonViewBody> createState() => _AddNewLessonViewBodyState();
}

class _AddNewLessonViewBodyState extends State<AddNewLessonViewBody> {
  final List<PlatformFile> _attachedFiles = [];

  String? _selectedSubject;
  String? _selectedSubjectId;
  String? _selectedClass;
  String? _selectedClassId;
  String? _selectedDateIso;

  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        final combined = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        setState(() {
          _dateTimeController.text =
              "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}, ${time.format(context)}";
          _selectedDateIso = combined.toIso8601String();
        });
      }
    }
  }

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

  void _submitLesson() {
    if (_titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        _selectedClassId == null ||
        _selectedSubjectId == null ||
        _selectedDateIso == null) {
      CustomSnackBar.showError(context, 'fill_required'.tr());
      return;
    }

    final parsedStart = DateTime.parse(_selectedDateIso!);
    final endTime = parsedStart.add(const Duration(hours: 1)).toIso8601String();

    context.read<AddLessonCubit>().createLesson(
      title: _titleController.text,
      description: _descController.text,
      date: _selectedDateIso!,
      startTime: _selectedDateIso!,
      endTime: endTime,
      classOid: _selectedClassId!,
      subjectOid: _selectedSubjectId!,
      type: 1,
      objectives: _descController.text
          .split('\n')
          .where((s) => s.trim().isNotEmpty)
          .toList(),
      attachedFiles: _attachedFiles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddLessonCubit, AddLessonState>(
      listener: (context, state) {
        if (state is AddLessonSuccess) {
          CustomSnackBar.showSuccess(context, state.message);
          Navigator.pop(context, true);
        } else if (state is AddLessonFailure) {
          CustomSnackBar.showError(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        final isLoading = state is AddLessonLoading;

        return Skeletonizer(
          enabled: isLoading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Lesson Title ────────────────────────────────────────────
                FieldLabel(label: 'lesson_title'.tr()),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _titleController,
                  hintText: 'lesson_title_hint'.tr(),
                ),

                const SizedBox(height: 20),

                // ── Subject ─────────────────────────────────────────────────
                FieldLabel(label: 'select_subject'.tr()),
                const SizedBox(height: 8),
                BlocBuilder<TeacherSubjectsCubit, TeacherSubjectsState>(
                  builder: (context, subjectState) {
                    if (subjectState is TeacherSubjectsLoading) {
                      return Skeletonizer(
                        enabled: true,
                        child: CustomDropdownField(
                          hintText: 'choose_subject'.tr(),
                          items: const ['Mathematics'],
                          value: 'Mathematics',
                          onChanged: (_) {},
                        ),
                      );
                    } else if (subjectState is TeacherSubjectsFailure) {
                      return Text(
                        subjectState.error.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      );
                    } else if (subjectState is TeacherSubjectsSuccess) {
                      final subjectNames = subjectState.subjects
                          .map((e) => e.name)
                          .toList();
                      return CustomDropdownField(
                        hintText: 'choose_subject'.tr(),
                        items: subjectNames,
                        value: _selectedSubject,
                        onChanged: isLoading
                            ? null
                            : (val) {
                                setState(() {
                                  _selectedSubject = val;
                                  final selected = subjectState.subjects
                                      .firstWhere((e) => e.name == val);
                                  _selectedSubjectId = selected.oid;
                                });
                              },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 20),

                // ── Class / Section ─────────────────────────────────────────
                FieldLabel(label: 'class_section'.tr()),
                const SizedBox(height: 8),
                BlocBuilder<TeacherClassesCubit, TeacherClassesState>(
                  builder: (context, classState) {
                    if (classState is TeacherClassesLoading) {
                      return Skeletonizer(
                        enabled: true,
                        child: CustomDropdownField(
                          hintText: 'choose_class'.tr(),
                          items: const ['Grade 10 - A'],
                          value: 'Grade 10 - A',
                          onChanged: (_) {},
                        ),
                      );
                    } else if (classState is TeacherClassesFailure) {
                      return Text(
                        classState.error.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      );
                    } else if (classState is TeacherClassesSuccess) {
                      final classNames = classState.classes
                          .map((e) => e.name)
                          .toList();
                      return CustomDropdownField(
                        hintText: 'choose_class'.tr(),
                        items: classNames,
                        value: _selectedClass,
                        onChanged: isLoading
                            ? null
                            : (val) {
                                setState(() {
                                  _selectedClass = val;
                                  final selected = classState.classes
                                      .firstWhere((e) => e.name == val);
                                  _selectedClassId = selected.oid;
                                });
                              },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 20),

                // ── Scheduled Date & Time ────────────────────────────────────
                FieldLabel(label: 'scheduled_date_time'.tr()),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'select_date_time'.tr(),
                  controller: _dateTimeController,
                  readOnly: true,
                  onTap: isLoading ? null : _pickDateTime,
                ),

                const SizedBox(height: 20),

                // ── Description / Objectives ─────────────────────────────────
                FieldLabel(label: 'desc_objectives'.tr()),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _descController,
                  hintText: 'learn_hint'.tr(),
                  maxLines: 4,
                ),

                const SizedBox(height: 20),

                // ── Attachments ──────────────────────────────────────────────
                FieldLabel(label: 'attachments'.tr()),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DashedUploadButton(
                        title: 'upload_pdf'.tr(),
                        icon: Icons.picture_as_pdf_outlined,
                        onTap: isLoading ? () {} : _pickPDFs,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DashedUploadButton(
                        title: 'add_images'.tr(),
                        icon: Icons.image_outlined,
                        onTap: isLoading ? () {} : _pickImages,
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
                      padding: const EdgeInsets.only(bottom: 10),
                      child: LessonFileCard(
                        fileName: file.name,
                        fileInfo:
                            '$sizeStr • ${isPdf ? 'PDF Document' : 'Image'}',
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

                // ── Publish Button ───────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : _submitLesson,
                    icon: Icon(Icons.upload, color: AppColors.white, size: 20),
                    label: Text(
                      'publish_lesson'.tr(),
                      style: TextStyle(
                        color: AppColors.white,
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
          ),
        );
      },
    );
  }
}
