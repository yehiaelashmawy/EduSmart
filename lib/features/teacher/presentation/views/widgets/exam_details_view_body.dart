import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/section_header.dart';

class ExamDetailsViewBody extends StatelessWidget {
  const ExamDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopCard(),
          const SizedBox(height: 24),
          const SectionHeader(
            icon: Icons.info_outline,
            title: 'Instructions for Students',
          ),
          const SizedBox(height: 16),
          _buildInstructionsList(),
          const SizedBox(height: 24),
          const SectionHeader(
            icon: Icons.description_outlined,
            title: 'Reference Materials',
          ),
          const SizedBox(height: 16),
          _buildReferenceCard(
            'Formula Sheet - Algebra.pdf',
            '2.4 MB • PDF Document',
            true,
          ),
          const SizedBox(height: 12),
          _buildReferenceCard(
            'Sample Question Paper 2023.docx',
            '1.1 MB • Word Document',
            false,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTopCard() {
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
                  color: const Color(0xffEFF6FF), // very light blue
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
                      'Final Term Examination',
                      style: AppTextStyle.bold18.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mathematics Grade 10 • Section B',
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
                  'DATE',
                  'Oct 24, 2023',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoBox(Icons.access_time, 'TIME', '09:00 AM'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoBox(
                  Icons.hourglass_empty,
                  'DURATION',
                  '120 Minutes',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoBox(
                  Icons.location_on_outlined,
                  'LOCATION',
                  'Hall A, Floor 2',
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

  Widget _buildInstructionsList() {
    final instructions = [
      'Please arrive 15 minutes before the exam starts.',
      'Scientific calculators are permitted for section B only.',
      'Mobile phones and smartwatches must be turned off and placed in bags.',
      'Students must carry their valid institutional ID cards.',
    ];

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
                    text,
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

  Widget _buildReferenceCard(String title, String subtitle, bool isPdf) {
    return Container(
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
              color: isPdf ? const Color(0xffFEE2E2) : const Color(0xffDBEAFE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPdf ? Icons.picture_as_pdf : Icons.article,
              color: isPdf ? const Color(0xffDC2626) : const Color(0xff2563EB),
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
                  style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.file_download_outlined,
              color: AppColors.secondaryColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
