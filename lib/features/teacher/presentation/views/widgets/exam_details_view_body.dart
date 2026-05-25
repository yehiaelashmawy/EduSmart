import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/helper/localization_helper.dart';
import 'package:school_system/core/helper/url_helper.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:school_system/features/teacher/data/models/teacher_exam_model.dart';
import 'package:school_system/features/teacher/data/repos/teacher_exams_repo.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/section_header.dart';

class ExamDetailsViewBody extends StatelessWidget {
  const ExamDetailsViewBody({super.key, this.examId});

  final String? examId;

  static final _dummyExam = TeacherExamModel(
    oid: '1',
    name: 'Midterm Examination',
    description: 'General mathematics midterm exam',
    type: 'Written',
    subjectName: 'Mathematics',
    className: 'Grade 10-A',
    date: '2024-05-20',
    startTime: '09:00',
    duration: '02:00',
    maxScore: 100,
    passingScore: 50,
    status: 'Upcoming',
    room: 'Hall A',
    studentsCount: 30,
    instructions: 'Please bring your own calculator.\nNo cell phones allowed.',
    materials: [
      {
        'name': 'Exam_Manual.pdf',
        'fileSize': 1024 * 500,
        'fileType': 'application/pdf',
      },
    ],
  );

  Future<TeacherExamModel?> _fetchExamDetails() async {
    if (examId == null || examId!.trim().isEmpty) return null;

    final repo = TeacherExamsRepo(ApiService());
    final result = await repo.getExamDetails(examId!);

    return result.fold((failure) => null, (exam) => exam);
  }

  Future<void> _openOrDownloadFile({
    required BuildContext context,
    required Map<String, dynamic> material,
    required bool showSavedMessage,
  }) async {
    final fileName = material['name']?.toString() ?? 'exam_file';
    final rawUrl = material['fileUrl']?.toString() ?? '';

    if (rawUrl.trim().isEmpty) {
      CustomSnackBar.showError(context, 'file_url_missing'.tr());
      return;
    }

    final fileUrl = UrlHelper.getFullImageUrl(rawUrl);

    if (fileUrl.trim().isEmpty) {
      CustomSnackBar.showError(context, 'invalid_file_url'.tr());
      return;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$fileName';

      await Dio().download(fileUrl, filePath);
      await OpenFilex.open(filePath);

      if (!context.mounted) return;

      if (showSavedMessage) {
        CustomSnackBar.showSuccess(
          context,
          'file_downloaded_successfully'.tr(),
        );
      }
    } catch (_) {
      if (!context.mounted) return;

      CustomSnackBar.showError(context, 'failed_open_download_file'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TeacherExamModel?>(
      future: _fetchExamDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Skeletonizer(
            enabled: true,
            child: _buildContent(context, _dummyExam),
          );
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data == null) {
          return Center(
            child: Text(
              'failed_load_exam_details'.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final exam = snapshot.data!;
        return _buildContent(context, exam);
      },
    );
  }

  Widget _buildContent(BuildContext context, TeacherExamModel exam) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopCard(exam),
          const SizedBox(height: 24),

          SectionHeader(
            icon: Icons.info_outline,
            title: 'instructions_students'.tr(),
          ),

          const SizedBox(height: 16),

          _buildInstructionsList(exam.instructions),

          const SizedBox(height: 24),

          if (exam.materials.isNotEmpty) ...[
            SectionHeader(
              icon: Icons.description_outlined,
              title: 'reference_materials'.tr(),
            ),

            const SizedBox(height: 16),

            ...exam.materials.map((material) {
              final matMap = material as Map<String, dynamic>;

              final isPdf =
                  matMap['fileType']?.toString().contains('pdf') ?? false;

              final sizeInKb = ((matMap['fileSize'] as num?) ?? 0) / 1024;

              final sizeText = sizeInKb > 1024
                  ? '${(sizeInKb / 1024).toStringAsFixed(1)} MB'
                  : '${sizeInKb.toStringAsFixed(1)} KB';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildReferenceCard(
                  title: matMap['name']?.toString() ?? 'Material',
                  subtitle:
                      '$sizeText • ${isPdf ? 'pdf_document'.tr() : 'document'.tr()}',
                  isPdf: isPdf,
                  onTap: () => _openOrDownloadFile(
                    context: context,
                    material: matMap,
                    showSavedMessage: false,
                  ),
                  onDownloadTap: () => _openOrDownloadFile(
                    context: context,
                    material: matMap,
                    showSavedMessage: true,
                  ),
                ),
              );
            }),

            const SizedBox(height: 32),
          ],
        ],
      ),
    );
  }

  Widget _buildTopCard(TeacherExamModel exam) {
    final parsedDate = DateTime.tryParse(exam.date);

    final dateStr = parsedDate != null
        ? DateFormat('MMM dd, yyyy').format(parsedDate)
        : exam.date;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: const Color(0xffEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.edit_document,
                  color: Color(0xff2563EB),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.name,
                      style: AppTextStyle.bold18.copyWith(
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${exam.subjectName} ${exam.className} • ${exam.type}',
                      style: AppTextStyle.regular14.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _buildInfoBox(
                  Icons.calendar_today_outlined,
                  'date_label'.tr(),
                  dateStr,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _buildInfoBox(
                  Icons.access_time,
                  'time_label'.tr(),
                  exam.startTime,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildInfoBox(
                  Icons.hourglass_empty,
                  'duration_label'.tr(),
                  '${exam.duration} ${'minutes'.tr()}',
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _buildInfoBox(
                  Icons.location_on_outlined,
                  'location_label'.tr(),
                  exam.room.isNotEmpty ? exam.room : 'not_available'.tr(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.secondaryColor),

              const SizedBox(width: 4),

              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            value,
            style: AppTextStyle.semiBold14.copyWith(color: AppColors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsList(String instructionsStr) {
    final instructions = instructionsStr
        .split('\n')
        .where((s) => s.trim().isNotEmpty)
        .toList();

    if (instructions.isEmpty) {
      return Text(
        'no_specific_instructions'.tr(),
        style: const TextStyle(color: Colors.grey),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: instructions.map((text) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    height: 4,
                    width: 4,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    text.trim(),
                    style: AppTextStyle.regular14.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReferenceCard({
    required String title,
    required String subtitle,
    required bool isPdf,
    required VoidCallback onTap,
    required VoidCallback onDownloadTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: isPdf
                    ? const Color(0xffFEE2E2)
                    : const Color(0xffDBEAFE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isPdf ? Icons.picture_as_pdf : Icons.article,
                color: isPdf
                    ? const Color(0xffDC2626)
                    : const Color(0xff2563EB),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.semiBold14.copyWith(
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: AppTextStyle.regular12.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              icon: Icon(
                Icons.file_download_outlined,
                color: AppColors.secondaryColor,
              ),
              onPressed: onDownloadTap,
            ),
          ],
        ),
      ),
    );
  }
}
