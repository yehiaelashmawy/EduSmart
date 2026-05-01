import 'package:flutter/material.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/exam_details_view_body.dart';

class ExamDetailsView extends StatefulWidget {
  const ExamDetailsView({super.key, this.examId});

  final String? examId;
  static const String routeName = '/exam_details';

  @override
  State<ExamDetailsView> createState() => _ExamDetailsViewState();
}

class _ExamDetailsViewState extends State<ExamDetailsView> {
  Future<void> _deleteExam() async {
    final examId = widget.examId;
    if (examId == null || examId.trim().isEmpty) {
      CustomSnackBar.showError(context, 'Exam ID is missing');
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Exam'),
        content: const Text('Are you sure you want to delete this exam?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response = await ApiService().delete('/api/Exams/$examId');
      final isSuccess =
          response is Map<String, dynamic> &&
          (response['success'] == true || response['data'] == true);

      if (!mounted) return;

      if (isSuccess) {
        CustomSnackBar.showSuccess(context, 'Exam deleted successfully');
        Navigator.pop(context, true);
      } else {
        CustomSnackBar.showError(context, 'Failed to delete exam');
      }
    } catch (_) {
      if (!mounted) return;
      CustomSnackBar.showError(context, 'Failed to delete exam');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Exam Details',
          style: AppTextStyle.bold18.copyWith(color: AppColors.darkBlue),
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.black),
            onPressed: _deleteExam,
          ),
        ],
      ),
      body: ExamDetailsViewBody(examId: widget.examId),
    );
  }
}
