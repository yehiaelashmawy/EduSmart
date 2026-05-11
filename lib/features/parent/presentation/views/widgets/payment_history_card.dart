import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class PaymentHistoryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String amount;
  final bool isPayNow;
  final bool isHighlighted;
  final VoidCallback? onPayPressed;
  final VoidCallback? onReceiptPressed;

  const PaymentHistoryCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isPayNow,
    this.isHighlighted = false,
    this.onPayPressed,
    this.onReceiptPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted ? AppColors.primaryColor : Colors.white,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.bold14.copyWith(color: AppColors.darkBlue),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTextStyle.bold16.copyWith(color: AppColors.darkBlue),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 28,
                child: ElevatedButton(
                  onPressed: isPayNow ? onPayPressed : onReceiptPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPayNow
                        ? const Color(0xFFD32F2F)
                        : const Color(0xFFE8F0FE),
                    foregroundColor: isPayNow ? Colors.white : AppColors.secondaryColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    isPayNow ? 'Pay Now' : 'Receipt',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isPayNow ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
