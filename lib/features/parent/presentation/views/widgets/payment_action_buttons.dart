import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/presentation/manager/parent_pay_cubit/parent_pay_cubit.dart';
import 'package:school_system/features/parent/presentation/manager/parent_pay_cubit/parent_pay_state.dart';

class PaymentActionButtons extends StatelessWidget {
  final VoidCallback onCancelPressed;
  final VoidCallback onPayPressed;

  const PaymentActionButtons({
    super.key,
    required this.onCancelPressed,
    required this.onPayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: onCancelPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,
            ),
            child: Text(
              'Cancel',
              style: AppTextStyle.bold16.copyWith(
                color: AppColors.secondaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: BlocBuilder<ParentPayCubit, ParentPayState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state is ParentPayLoading ? null : onPayPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: state is ParentPayLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pay Now',
                            style: AppTextStyle.bold16.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}
