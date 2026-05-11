import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/parent/data/models/payment_history_model.dart';
import 'package:school_system/features/parent/presentation/views/parent_receipt_view.dart';
import 'package:school_system/features/parent/presentation/views/parent_secure_payment_view.dart';
import 'payment_history_card.dart';

class PaymentHistoryList extends StatelessWidget {
  final bool showAllHistory;
  final List<PaymentHistoryItemModel> history;
  const PaymentHistoryList({
    super.key,
    required this.showAllHistory,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text('No payment history found'),
        ),
      );
    }

    final items = showAllHistory ? history : history.take(2).toList();

    return Column(
      children: items.map((item) {
        final iconData = _getIconForCategory(item.category);
        return PaymentHistoryCard(
          icon: iconData.$1,
          iconColor: iconData.$2,
          iconBgColor: iconData.$2.withOpacity(0.1),
          title: item.title,
          subtitle: _getSubtitle(item),
          amount: '\$${item.amount.toStringAsFixed(2)}',
          isPayNow: item.status.toLowerCase() == 'overdue' || item.canPay,
          isHighlighted: item.status.toLowerCase() == 'overdue',
          onPayPressed: () {
            Navigator.pushNamed(context, ParentSecurePaymentView.routeName);
          },
          onReceiptPressed: item.receiptNumber != null
              ? () {
                  Navigator.pushNamed(
                    context,
                    ParentReceiptView.routeName,
                    arguments: item.receiptNumber,
                  );
                }
              : null,
        );
      }).toList(),
    );
  }

  (IconData, Color) _getIconForCategory(String category) {
    category = category.toLowerCase();
    if (category.contains('tuition')) return (Icons.school_outlined, const Color(0xff004EEB));
    if (category.contains('lab')) return (Icons.science_outlined, const Color(0xffF04438));
    if (category.contains('activity') || category.contains('trip')) {
      return (Icons.sports_soccer_outlined, const Color(0xff12B76A));
    }
    if (category.contains('bus') || category.contains('transport')) {
      return (Icons.directions_bus_outlined, Colors.orange);
    }
    return (Icons.payments_outlined, AppColors.secondaryColor);
  }

  String _getSubtitle(PaymentHistoryItemModel item) {
    final dateStr = item.status.toLowerCase() == 'paid'
        ? 'Paid ${_formatDate(item.paidDate ?? item.dueDate)}'
        : 'Due ${_formatDate(item.dueDate)}';
    return '$dateStr • ${item.studentName}';
  }

  String _formatDate(String date) {
    try {
      final dateTime = DateTime.parse(date);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    } catch (e) {
      return date.split('T').first;
    }
  }
}
