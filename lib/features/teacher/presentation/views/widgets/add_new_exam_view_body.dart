import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/custom_text_field.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/exam_attachments_section.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/exam_details_section.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/exam_grading_section.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/exam_schedule_section.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/section_header.dart';
import 'package:school_system/features/teacher/presentation/manager/add_exam_cubit/add_exam_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/add_exam_cubit/add_exam_state.dart';
import 'package:school_system/features/teacher/data/models/add_exam_request.dart';
import 'package:file_picker/file_picker.dart';

class AddNewExamViewBody extends StatefulWidget {
  const AddNewExamViewBody({super.key});

  @override
  State<AddNewExamViewBody> createState() => _AddNewExamViewBodyState();
}

class _AddNewExamViewBodyState extends State<AddNewExamViewBody> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _totalMarksController = TextEditingController();
  final TextEditingController _passingMarksController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();

  String? _selectedSubjectOid;
  String? _selectedClassOid;
  String? _selectedType;
  List<PlatformFile> _attachedFiles = [];

  @override
  void dispose() {
    _titleController.dispose();
    _instructionsController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _durationController.dispose();
    _totalMarksController.dispose();
    _passingMarksController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleController.text.isEmpty ||
        _selectedSubjectOid == null ||
        _selectedClassOid == null ||
        _selectedType == null ||
        _dateController.text.isEmpty ||
        _startTimeController.text.isEmpty ||
        _durationController.text.isEmpty ||
        _totalMarksController.text.isEmpty ||
        _passingMarksController.text.isEmpty) {
      CustomSnackBar.showError(context, 'Please fill all required fields');
      return;
    }

    try {
      final request = AddExamRequest(
        name: _titleController.text,
        description: "",
        type: _selectedType!,
        subjectOid: _selectedSubjectOid!,
        classOid: _selectedClassOid!,
        date: _dateController.text,
        startTime: _startTimeController.text,
        duration: _durationController.text,
        maxScore: int.tryParse(_totalMarksController.text) ?? 100,
        passingScore: int.tryParse(_passingMarksController.text) ?? 50,
        room: _roomController.text,
        instructions: _instructionsController.text,
        materials: [],
      );

      context.read<AddExamCubit>().addExam(request, files: _attachedFiles);
    } catch (e) {
      CustomSnackBar.showError(context, 'Error parsing date/time: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddExamCubit, AddExamState>(
      listener: (context, state) {
        if (state is AddExamSuccess) {
          CustomSnackBar.showSuccess(context, 'Exam scheduled successfully');
          Navigator.pop(context, true);
        } else if (state is AddExamFailure) {
          CustomSnackBar.showError(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                icon: Icons.description_outlined,
                title: 'Exam Details',
              ),
              const SizedBox(height: 16),
              ExamDetailsSection(
                titleController: _titleController,
                onSubjectChanged: (val) => _selectedSubjectOid = val,
                onClassChanged: (val) => _selectedClassOid = val,
                onTypeChanged: (val) => _selectedType = val,
              ),
              const SizedBox(height: 24),
              const SectionHeader(
                icon: Icons.calendar_today_outlined,
                title: 'Schedule',
              ),
              const SizedBox(height: 16),
              ExamScheduleSection(
                dateController: _dateController,
                startTimeController: _startTimeController,
                durationController: _durationController,
                roomController: _roomController,
              ),
              const SizedBox(height: 24),
              const SectionHeader(
                icon: Icons.star_outline_rounded,
                title: 'Grading',
              ),
              const SizedBox(height: 16),
              ExamGradingSection(
                totalMarksController: _totalMarksController,
                passingMarksController: _passingMarksController,
              ),
              const SizedBox(height: 24),
              const SectionHeader(
                icon: Icons.info_outline_rounded,
                title: 'Exam Instructions',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Enter instructions for students...',
                maxLines: 4,
                controller: _instructionsController,
              ),
              const SizedBox(height: 24),
              const SectionHeader(
                icon: Icons.attachment_outlined,
                title: 'Attachments',
              ),
              const SizedBox(height: 16),
              ExamAttachmentsSection(
                onFilesChanged: (files) => _attachedFiles = files,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Skeletonizer(
                  enabled: state is AddExamLoading,
                  child: ElevatedButton.icon(
                    onPressed: state is AddExamLoading ? null : _submit,
                    icon: Icon(
                      Icons.send_outlined,
                      color: AppColors.white,
                      size: 20,
                    ),
                    label: Text(
                      'Schedule Exam',
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
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
