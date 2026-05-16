import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class OtpInputRow extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final int length;

  const OtpInputRow({
    super.key,
    required this.onCompleted,
    this.length = 6,
  });

  @override
  State<OtpInputRow> createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<OtpInputRow> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (index) => TextEditingController());
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _checkCompletion();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  void _checkCompletion() {
    String otp = _controllers.map((c) => c.text).join();
    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        widget.length,
        (index) => SizedBox(
          height: 64,
          width: widget.length == 6 ? 44 : 56, // Adjust width based on length
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            onChanged: (value) => _onChanged(value, index),
            textAlign: TextAlign.center,
            style: AppTextStyle.bold24.copyWith(color: AppColors.darkBlue),
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.backgroundColor,
              contentPadding: EdgeInsets.zero,
              border: buildBorder(),
              enabledBorder: buildBorder(),
              focusedBorder: buildBorder(AppColors.primaryColor),
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder buildBorder([Color? color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(width: 1, color: color ?? AppColors.lightGrey),
    );
  }
}
