import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.controller,
    this.maxLines = 1,
    this.minLines,
  });

  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final int? maxLines;
  final int? minLines;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool isObscure;

  @override
  void initState() {
    super.initState();
    isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: isObscure,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      maxLines: isObscure ? 1 : widget.maxLines,
      minLines: widget.minLines,
      style: AppTextStyle.regular16.copyWith(color: AppColors.darkBlue),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyle.regular16.copyWith(
          color: AppColors.grey.withValues(alpha: 0.7),
        ),
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: widget.prefixIcon,
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: widget.obscureText
            ? IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: Icon(
                  isObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.grey,
                  size: 20,
                ),
              )
            : (widget.suffixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: widget.suffixIcon,
                    )
                  : null),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: AppColors.backgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 17,
        ),
        border: buildBorder(),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(AppColors.primaryColor),
      ),
    );
  }

  OutlineInputBorder buildBorder([Color? color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: BorderSide(width: 1, color: color ?? AppColors.lightGrey),
    );
  }
}
