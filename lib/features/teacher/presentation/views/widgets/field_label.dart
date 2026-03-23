import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyle.semiBold14.copyWith(
        color: const Color(0xff334155), // Slate dark
        fontSize: 13,
      ),
    );
  }
}
