import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/code_option_button.dart';

class CodeSelectorCard extends StatelessWidget {
  final List<String> codes;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  const CodeSelectorCard({
    super.key,
    required this.codes,
    required this.activeIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'SELECT ACTIVE CODE',
            style: AppTextStyle.bold12.copyWith(
              color: AppColors.primaryColor,
              letterSpacing: 2.0,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              codes.length,
              (i) => CodeOptionButton(
                code: codes[i],
                isActive: i == activeIndex,
                onTap: () => onSelect(i),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
