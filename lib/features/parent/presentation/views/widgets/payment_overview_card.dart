import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class PaymentOverviewCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;
  final Color bgColor;
  final Color iconColor;
  final Color amountColor;
  final Color? titleColor;

  const PaymentOverviewCard({
    super.key,
    required this.icon,
    required this.title,
    required this.amount,
    required this.bgColor,
    required this.iconColor,
    required this.amountColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: iconColor, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.bold12.copyWith(
                  color: titleColor ?? AppColors.grey,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: AppTextStyle.bold18.copyWith(
                  color: amountColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
