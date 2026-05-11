import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/parent/data/models/payment_summary_model.dart';
import 'payment_overview_card.dart';

class PaymentOverviewGrid extends StatelessWidget {
  final PaymentSummaryModel summary;
  const PaymentOverviewGrid({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        PaymentOverviewCard(
          icon: Icons.check_circle_outline,
          title: 'TOTAL PAID',
          amount: '\$${summary.totalPaid.toStringAsFixed(0)}',
          bgColor: Colors.white,
          iconColor: AppColors.primaryColor,
          amountColor: Colors.black,
        ),
        PaymentOverviewCard(
          icon: Icons.access_time,
          title: 'PENDING',
          amount: '\$${summary.pending.toStringAsFixed(0)}',
          bgColor: Colors.white,
          iconColor: AppColors.primaryColor,
          amountColor: Colors.black,
        ),
        PaymentOverviewCard(
          icon: Icons.calendar_today_outlined,
          title: 'OVERDUE',
          amount: '\$${summary.overdue.toStringAsFixed(0)}',
          bgColor: const Color(0xFFFFF0F0),
          iconColor: const Color(0xFFD32F2F),
          amountColor: const Color(0xFFD32F2F),
          titleColor: const Color(0xFFD32F2F),
        ),
        PaymentOverviewCard(
          icon: Icons.account_balance_wallet_outlined,
          title: 'TOTAL DUE',
          amount: '\$${summary.totalDue.toStringAsFixed(0)}',
          bgColor: const Color(0xFFF0F4FF),
          iconColor: AppColors.secondaryColor,
          amountColor: AppColors.secondaryColor,
          titleColor: AppColors.secondaryColor,
        ),
      ],
    );
  }
}
