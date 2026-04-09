import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.maxLines = 1,
    this.minLines,
    this.suffixIcon,
    this.initialValue,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
  });

  final String hintText;
  final int maxLines;
  final Widget? suffixIcon;
  final String? initialValue;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final int? minLines;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      obscureText: obscureText,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      style: AppTextStyle.regular14.copyWith(color: AppColors.darkBlue),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyle.regular14.copyWith(
          color: AppColors.grey.withValues(alpha: 0.7),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}
