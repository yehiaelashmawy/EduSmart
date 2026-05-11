import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'payment_overview_card.dart';

class PaymentOverviewGrid extends StatelessWidget {
  const PaymentOverviewGrid({super.key});

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
          amount: '\$12,450',
          bgColor: Colors.white,
          iconColor: AppColors.primaryColor,
          amountColor: Colors.black,
        ),
        PaymentOverviewCard(
          icon: Icons.access_time,
          title: 'PENDING',
          amount: '\$850',
          bgColor: Colors.white,
          iconColor: AppColors.primaryColor,
          amountColor: Colors.black,
        ),
        const PaymentOverviewCard(
          icon: Icons.calendar_today_outlined,
          title: 'OVERDUE',
          amount: '\$320',
          bgColor: Color(0xFFFFF0F0),
          iconColor: Color(0xFFD32F2F),
          amountColor: Color(0xFFD32F2F),
          titleColor: Color(0xFFD32F2F),
        ),
        PaymentOverviewCard(
          icon: Icons.account_balance_wallet_outlined,
          title: 'TOTAL DUE',
          amount: '\$1,170',
          bgColor: Color(0xFFF0F4FF),
          iconColor: AppColors.secondaryColor,
          amountColor: AppColors.secondaryColor,
          titleColor: AppColors.secondaryColor,
        ),
      ],
    );
  }
}
