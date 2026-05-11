import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class PaymentTotalAmountCard extends StatelessWidget {
  final double amount;
  const PaymentTotalAmountCard({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL AMOUNT',
                style: AppTextStyle.bold12.copyWith(
                  color: AppColors.secondaryColor,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${amount.toStringAsFixed(2)}',
                style: AppTextStyle.bold36.copyWith(
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.verified, color: AppColors.secondaryColor, size: 14),
                const SizedBox(width: 4),
                Text(
                  'BANK GRADE SECURITY',
                  style: AppTextStyle.bold12.copyWith(
                    color: AppColors.secondaryColor,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
