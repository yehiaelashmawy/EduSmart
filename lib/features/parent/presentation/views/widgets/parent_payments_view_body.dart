import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'payment_history_list.dart';
import 'payment_overdue_banner.dart';
import 'payment_overview_grid.dart';

class ParentPaymentsViewBody extends StatefulWidget {
  const ParentPaymentsViewBody({super.key});

  @override
  State<ParentPaymentsViewBody> createState() => _ParentPaymentsViewBodyState();
}

class _ParentPaymentsViewBodyState extends State<ParentPaymentsViewBody> {
  bool _showAllHistory = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          const PaymentOverviewGrid(),
          const SizedBox(height: 24),
          const PaymentOverdueBanner(),
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showAllHistory = !_showAllHistory;
                  });
                },
                child: Text(
                  _showAllHistory ? 'Show Less <' : 'View All >',
                  style: AppTextStyle.semiBold14.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PaymentHistoryList(showAllHistory: _showAllHistory),
        ],
      ),
    );
  }
}
