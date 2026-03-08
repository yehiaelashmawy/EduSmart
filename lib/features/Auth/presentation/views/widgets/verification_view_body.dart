import 'dart:async';
import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/widgets/custom_app_bar.dart';
import 'package:school_system/core/widgets/custom_button.dart';
import 'package:school_system/features/Auth/presentation/views/widgets/otp_input_row.dart';
import 'package:svg_flutter/svg.dart';

class VerificationViewBody extends StatefulWidget {
  const VerificationViewBody({super.key});

  @override
  State<VerificationViewBody> createState() => _VerificationViewBodyState();
}

class _VerificationViewBodyState extends State<VerificationViewBody> {
  Timer? _timer;
  int _start = 179; // 02:59 in seconds

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppBar(title: 'Verification'),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        'assets/images/verivication_code.svg',
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Verification Code',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bold24,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enter the 4-digit code sent to your email or phone to reset your password.',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.regular16.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const OtpInputRow(),
                    const SizedBox(height: 40),
                    const CustomButton(text: 'Verify & Continue'),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the code? ",
                          style: AppTextStyle.regular14.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_start == 0) {
                              setState(() {
                                _start = 179;
                                startTimer();
                              });
                            }
                          },
                          child: Text(
                            'Resend Code',
                            style: AppTextStyle.bold14.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppColors.lightGrey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          timerText,
                          style: AppTextStyle.regular14.copyWith(
                            color: AppColors.lightGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
