import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/features/teacher/presentation/manager/add_homework_cubit/add_homework_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/add_homework_cubit/add_homework_state.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/custom_dropdown_field.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/custom_text_field.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/field_label.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/homework_attachments_section.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/homework_due_date_time_section.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_classes_cubit/teacher_classes_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_classes_cubit/teacher_classes_state.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_subjects_cubit/teacher_subjects_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_subjects_cubit/teacher_subjects_state.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/homework_file_list.dart';
import 'package:school_system/core/helper/localization_helper.dart';

class AddHomeworkViewBody extends StatefulWidget {
  const AddHomeworkViewBody({super.key});

  @override
  State<AddHomeworkViewBody> createState() => _AddHomeworkViewBodyState();
}

class _AddHomeworkViewBodyState extends State<AddHomeworkViewBody> {
  final List<PlatformFile> _attachedFiles = [];
  String? _selectedClass;
  String? _selectedClassId;
  String? _selectedSubject;
  String? _selectedSubjectId;
  String? _dueDate;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _instController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _instController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _attachedFiles.addAll(result.files);
      });
    }
  }

  void _submitHomework() {
    if (_titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        _instController.text.isEmpty ||
        _pointsController.text.isEmpty ||
        _selectedClassId == null ||
        _selectedSubjectId == null ||
        _dueDate == null) {
      CustomSnackBar.showError(context, 'fill_required'.tr());
      return;
    }

    final points = int.tryParse(_pointsController.text) ?? 0;

    context.read<AddHomeworkCubit>().createHomework(
      title: _titleController.text,
      description: _descController.text,
      instructions: _instController.text,
      dueDate: _dueDate!,
      totalMarks: points,
      classId: _selectedClassId!,
      subjectId: _selectedSubjectId!,
      submissionType: "file",
      allowLateSubmissions: true,
      notifyParents: true,
      attachedFiles: _attachedFiles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddHomeworkCubit, AddHomeworkState>(
      listener: (context, state) {
        if (state is AddHomeworkSuccess) {
          CustomSnackBar.showSuccess(context, state.message);
          Navigator.pop(context, true); // Go back after success
        } else if (state is AddHomeworkFailure) {
          CustomSnackBar.showError(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        final isLoading = state is AddHomeworkLoading;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldLabel(label: 'select_class'.tr()),
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

                    // Reset _selectedClass if it's not in the new list
                    if (_selectedClass != null &&
                        !classNames.contains(_selectedClass)) {
                      _selectedClass = null;
                      _selectedClassId = null;
                    }

                    return CustomDropdownField(
                      hintText: 'choose_class'.tr(),
                      items: classNames,
                      value: _selectedClass,
                      onChanged: (val) {
                        setState(() {
                          _selectedClass = val;
                          final selectedModel = classState.classes.firstWhere(
                            (e) => e.name == val,
                          );
                          _selectedClassId = selectedModel.oid;
                        });
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 20),

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

                    if (_selectedSubject != null &&
                        !subjectNames.contains(_selectedSubject)) {
                      _selectedSubject = null;
                      _selectedSubjectId = null;
                    }

                    return CustomDropdownField(
                      hintText: 'choose_subject'.tr(),
                      items: subjectNames,
                      value: _selectedSubject,
                      onChanged: (val) {
                        setState(() {
                          _selectedSubject = val;
                          final selectedModel = subjectState.subjects
                              .firstWhere((e) => e.name == val);
                          _selectedSubjectId = selectedModel.oid;
                        });
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 20),

              FieldLabel(label: 'homework_title'.tr()),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _titleController,
                hintText: 'homework_title_hint'.tr(),
              ),
              const SizedBox(height: 20),

              FieldLabel(label: 'description'.tr()),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _descController,
                hintText: 'description_hint'.tr(),
                minLines: 3,
                maxLines: 5,
              ),
              const SizedBox(height: 20),

              FieldLabel(label: 'instructions'.tr()),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _instController,
                hintText: 'instructions_hint'.tr(),
                minLines: 4,
                maxLines: 6,
              ),
              const SizedBox(height: 20),

              HomeworkDueDateTimeSection(
                onDateTimeStringChanged: (val) {
                  _dueDate = val;
                },
              ),
              const SizedBox(height: 20),

              FieldLabel(label: 'points_grade'.tr()),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _pointsController,
                hintText: '100',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              FieldLabel(label: 'attachments'.tr()),
              const SizedBox(height: 12),
              HomeworkAttachmentsSection(onTap: _pickFiles),

              HomeworkFileList(attachedFiles: _attachedFiles),

              const SizedBox(height: 40),

              isLoading
                  ? Skeletonizer(
                      enabled: true,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: null,
                          icon: Icon(
                            Icons.send_outlined,
                            color: AppColors.white,
                            size: 20,
                          ),
                          label: Text(
                            'create_homework'.tr(),
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
                    )
                  : _buildCreateButton(),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _submitHomework,
        icon: Icon(Icons.send_outlined, color: AppColors.white, size: 20),
        label: Text(
          'create_homework'.tr(),
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
    );
  }
}
