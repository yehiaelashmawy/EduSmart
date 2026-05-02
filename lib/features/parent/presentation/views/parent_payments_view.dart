import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/presentation/views/parent_secure_payment_view.dart';

class ParentPaymentsView extends StatelessWidget {
  static const routeName = 'parent_payments_view';
  const ParentPaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        titleSpacing: 8,
        title: Text(
          'School Payments',
          style: AppTextStyle.bold20.copyWith(color: AppColors.primaryColor),
        ),
        centerTitle: false,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Overview',
              style: AppTextStyle.bold18.copyWith(
                color: AppColors.secondaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildOverviewGrid(),
            const SizedBox(height: 24),
            _buildOverdueBanner(context),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment History',
                  style: AppTextStyle.bold18.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
                Text(
                  'View All >',
                  style: AppTextStyle.semiBold14.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPaymentHistoryList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildOverviewCard(
          icon: Icons.check_circle_outline,
          title: 'TOTAL PAID',
          amount: '\$12,450',
          bgColor: Colors.white,
          iconColor: AppColors.primaryColor,
          amountColor: Colors.black,
        ),
        _buildOverviewCard(
          icon: Icons.access_time,
          title: 'PENDING',
          amount: '\$850',
          bgColor: Colors.white,
          iconColor: AppColors.primaryColor,
          amountColor: Colors.black,
        ),
        _buildOverviewCard(
          icon: Icons.calendar_today_outlined,
          title: 'OVERDUE',
          amount: '\$320',
          bgColor: const Color(0xFFFFF0F0), // Light red
          iconColor: const Color(0xFFD32F2F),
          amountColor: const Color(0xFFD32F2F),
          titleColor: const Color(0xFFD32F2F),
        ),
        _buildOverviewCard(
          icon: Icons.account_balance_wallet_outlined,
          title: 'TOTAL DUE',
          amount: '\$1,170',
          bgColor: const Color(0xFFF0F4FF), // Light blue
          iconColor: AppColors.secondaryColor,
          amountColor: AppColors.secondaryColor,
          titleColor: AppColors.secondaryColor,
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
    required IconData icon,
    required String title,
    required String amount,
    required Color bgColor,
    required Color iconColor,
    required Color amountColor,
    Color? titleColor,
  }) {
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTextStyle.bold12.copyWith(
                  color: titleColor ?? Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(amount, style: AppTextStyle.bold24.copyWith(color: amountColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverdueBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE5E5), // Lighter red for background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFC62828), // Dark red for icon background
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overdue payments detected',
                  style: AppTextStyle.bold14.copyWith(
                    color: const Color(0xFFC62828),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Settle outstanding fees to avoid late charges.',
                  style: AppTextStyle.regular12.copyWith(
                    color: const Color(0xFFC62828),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, ParentSecurePaymentView.routeName);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC62828),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Pay\nNow',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryList(BuildContext context) {
    return Column(
      children: [
        _buildHistoryCard(
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
        _buildHistoryCard(
          icon: Icons.menu_book_outlined,
          iconColor: AppColors.secondaryColor,
          iconBgColor: AppColors.primaryColor.withValues(alpha: 0.1),
          title: 'Textbook Bundle (Grade 4)',
          subtitle: 'Paid Nov 02, 2023 • Leo Smith',
          amount: '\$145.00',
          isPayNow: false,
        ),
        _buildHistoryCard(
          icon: Icons.directions_bus_outlined,
          iconColor: AppColors.secondaryColor,
          iconBgColor: AppColors.primaryColor.withValues(alpha: 0.1),
          title: 'Transport Fee - November',
          subtitle: 'Paid Oct 28, 2023 • Sarah Smith',
          amount: '\$85.00',
          isPayNow: false,
        ),
        _buildHistoryCard(
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
      ],
    );
  }

  Widget _buildHistoryCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required String amount,
    required bool isPayNow,
    bool isHighlighted = false,
    VoidCallback? onPayPressed,
  }) {
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.bold14.copyWith(color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyle.regular12.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTextStyle.bold16.copyWith(color: Colors.black87),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 28,
                child: ElevatedButton(
                  onPressed: isPayNow ? onPayPressed : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPayNow
                        ? AppColors.secondaryColor
                        : const Color(0xFFE8F0FE),
                    foregroundColor: isPayNow
                        ? Colors.white
                        : AppColors.secondaryColor,
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
