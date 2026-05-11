import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputLabel('PAYMENT METHOD'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.secondaryColor, width: 1.5),
            ),
            child: Row(
              children: [
                Icon(Icons.paypal, color: AppColors.secondaryColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  'PayPal',
                  style: AppTextStyle.bold16.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
                const Spacer(),
                Icon(Icons.check_circle, color: AppColors.secondaryColor),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'You will be redirected to PayPal to complete your purchase securely.',
            style: AppTextStyle.medium12.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: AppTextStyle.bold12.copyWith(
          color: Colors.grey.shade700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
