import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class OtpInputRow extends StatelessWidget {
  const OtpInputRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) => const OtpInputItem()),
    );
  }
}

class OtpInputItem extends StatelessWidget {
  const OtpInputItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: 56,
      child: TextField(
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        textAlign: TextAlign.center,
        style: AppTextStyle.bold24.copyWith(color: AppColors.darkBlue),
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: EdgeInsets.zero,
          border: buildBorder(),
          enabledBorder: buildBorder(),
          focusedBorder: buildBorder(AppColors.primaryColor),
        ),
      ),
    );
  }

  OutlineInputBorder buildBorder([Color? color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(width: 1, color: color ?? const Color(0xFFE2E8F0)),
    );
  }
}
