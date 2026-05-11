import 'package:flutter/material.dart';
import 'package:school_system/features/parent/data/models/parent_dashboard_model.dart';
import 'package:school_system/features/parent/presentation/views/widgets/child_details_header.dart';
import 'package:school_system/features/parent/presentation/views/widgets/kid_attendance_tab.dart';
import 'package:school_system/features/parent/presentation/views/widgets/kid_coming_soon.dart';
import 'package:school_system/features/parent/presentation/views/widgets/kid_grades_tab.dart';
import 'package:school_system/features/parent/presentation/views/widgets/kid_homework_tab.dart';
import 'package:school_system/features/parent/presentation/views/widgets/kid_overview_tab.dart';
import 'package:school_system/features/parent/presentation/views/widgets/quick_actions_tabs.dart';

class ParentMyKidsViewBody extends StatefulWidget {
  final ParentChildModel? child;
  const ParentMyKidsViewBody({super.key, this.child});

  @override
  State<ParentMyKidsViewBody> createState() => _ParentMyKidsViewBodyState();
}

class _ParentMyKidsViewBodyState extends State<ParentMyKidsViewBody> {
  int _selectedTabIndex = 0;

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0: return const KidOverviewTab();
      case 1: return KidAttendanceTab(childId: widget.child?.childId);
      case 2: return KidGradesTab(childId: widget.child?.childId);
      case 3: return KidHomeworkTab(childId: widget.child?.childId);
      default: return const KidComingSoon();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChildDetailsHeader(child: widget.child),
          const SizedBox(height: 16),
          QuickActionsTabs(
            currentIndex: _selectedTabIndex,
            onTabChanged: (index) => setState(() => _selectedTabIndex = index),
          ),
          const SizedBox(height: 24),
          _buildTabContent(),
        ],
      ),
    );
  }
}
