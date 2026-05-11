import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/parent/presentation/views/parent_receipt_view.dart';
import 'package:school_system/features/parent/presentation/views/parent_secure_payment_view.dart';
import 'payment_history_card.dart';

class PaymentHistoryList extends StatelessWidget {
  final bool showAllHistory;
  const PaymentHistoryList({super.key, required this.showAllHistory});

  @override
  Widget build(BuildContext context) {
    final List<Widget> historyCards = [
      PaymentHistoryCard(
        icon: Icons.school_outlined,
        iconColor: const Color(0xFFD32F2F),
        iconBgColor: const Color(0xFFFFF0F0),
        title: 'Annual Tuition Fee - Term 2',
        subtitle: 'Due Oct 15, 2023 • Leo Smith',
        amount: '\$320.00',
        isPayNow: true,
        onPayPressed: () {
          Navigator.pushNamed(context, ParentSecurePaymentView.routeName);
        },
      ),
      PaymentHistoryCard(
        icon: Icons.menu_book_outlined,
        iconColor: AppColors.secondaryColor,
        iconBgColor: AppColors.primaryColor.withValues(alpha: 0.1),
        title: 'Textbook Bundle (Grade 4)',
        subtitle: 'Paid Nov 02, 2023 • Leo Smith',
        amount: '\$145.00',
        isPayNow: false,
        onReceiptPressed: () {
          Navigator.pushNamed(context, ParentReceiptView.routeName);
        },
      ),
      PaymentHistoryCard(
        icon: Icons.directions_bus_outlined,
        iconColor: AppColors.secondaryColor,
        iconBgColor: AppColors.primaryColor.withValues(alpha: 0.1),
        title: 'Transport Fee - November',
        subtitle: 'Paid Oct 28, 2023 • Sarah Smith',
        amount: '\$85.00',
        isPayNow: false,
        onReceiptPressed: () {
          Navigator.pushNamed(context, ParentReceiptView.routeName);
        },
      ),
      PaymentHistoryCard(
        icon: Icons.sports_soccer_outlined,
        iconColor: Colors.grey.shade700,
        iconBgColor: Colors.grey.shade200,
        title: 'Sports Club Registration',
        subtitle: 'Due Nov 30, 2023 • Sarah Smith',
        amount: '\$210.00',
        isPayNow: true,
        isHighlighted: true,
        onPayPressed: () {
          Navigator.pushNamed(context, ParentSecurePaymentView.routeName);
        },
      ),
    ];

    return Column(
      children: showAllHistory ? historyCards : historyCards.take(2).toList(),
    );
  }
}
