import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class CustomDropdownField extends StatelessWidget {
  const CustomDropdownField({
    super.key,
    required this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final String hintText;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffE2E8F0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(
            hintText,
            style: AppTextStyle.regular14.copyWith(color: AppColors.darkBlue),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.primaryColor,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: AppTextStyle.regular14.copyWith(
                  color: AppColors.darkBlue,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
