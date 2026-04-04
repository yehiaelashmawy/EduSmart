import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/active_course_card.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/code_selector_card.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/joined_students_card.dart';

class EntryCodeViewBody extends StatefulWidget {
  const EntryCodeViewBody({super.key});

  @override
  State<EntryCodeViewBody> createState() => _EntryCodeViewBodyState();
}

class _EntryCodeViewBodyState extends State<EntryCodeViewBody> {
  static const int _totalStudents = 45;

  List<String> _codes = ['84', '29', '17'];
  int _activeCodeIndex = 0;
  int _joinedCount = 32;
  late Timer _joinTimer;

  @override
  void initState() {
    super.initState();
    // Simulate students joining every ~2 seconds until all joined
    _joinTimer = Timer.periodic(const Duration(milliseconds: 2000), (_) {
      if (_joinedCount >= _totalStudents) {
        _joinTimer.cancel();
        return;
      }
      if (mounted) {
        setState(() => _joinedCount++);
      }
    });
  }

  @override
  void dispose() {
    _joinTimer.cancel();
    super.dispose();
  }

  void _generateNewCode() {
    final rng = Random();
    setState(() {
      _codes = List.generate(3, (_) => (rng.nextInt(90) + 10).toString());
      _activeCodeIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 28),
                CodeSelectorCard(
                  codes: _codes,
                  activeIndex: _activeCodeIndex,
                  onSelect: (i) => setState(() => _activeCodeIndex = i),
                ),
                const SizedBox(height: 24),
                const _SectionDivider(),
                const SizedBox(height: 20),
                const ActiveCourseCard(
                  courseName: 'Advanced Pedagogy 402',
                  location: 'Main Lecture Hall C',
                ),
                const SizedBox(height: 20),
                const _SectionDivider(),
                const SizedBox(height: 20),
                JoinedStudentsCard(
                  joined: _joinedCount,
                  total: _totalStudents,
                ),
              ],
            ),
          ),
        ),
        _buildGenerateButton(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live Attendance Session',
          style: AppTextStyle.bold16.copyWith(
            color: AppColors.black,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: AppTextStyle.medium14.copyWith(
              color: AppColors.grey,
              height: 1.5,
            ),
            children: [
              const TextSpan(
                text: 'Please select the correct code for students to match in their ',
              ),
              TextSpan(
                text: 'Academic Curator',
                style: AppTextStyle.medium14.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              const TextSpan(text: ' app.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
        child: GestureDetector(
          onTap: _generateNewCode,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.refresh_rounded,
                  color: Color(0xff065AD8),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Generate New Code',
                  style: AppTextStyle.semiBold16.copyWith(
                    color: const Color(0xff065AD8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.lightGrey.withOpacity(0.4),
      thickness: 1,
      height: 1,
    );
  }
}
