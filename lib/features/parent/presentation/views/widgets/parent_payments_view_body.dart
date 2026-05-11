import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/features/parent/data/models/payment_summary_model.dart';
import 'package:school_system/features/parent/presentation/manager/parent_payments_cubit/parent_payments_cubit.dart';
import 'package:school_system/features/parent/presentation/manager/parent_payments_cubit/parent_payments_state.dart';
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
    return BlocBuilder<ParentPaymentsCubit, ParentPaymentsState>(
      builder: (context, state) {
        if (state is ParentPaymentsFailure) {
          return Center(child: Text(state.error.errorMessage));
        }

        final bool isLoading = state is ParentPaymentsLoading;
        final summary = state is ParentPaymentsSuccess
            ? state.summary
            : _getMockSummary();

        return Skeletonizer(
          enabled: isLoading,
          child: SingleChildScrollView(
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
                PaymentOverviewGrid(summary: summary),
                const SizedBox(height: 24),
                if (summary.hasOverduePayments)
                  PaymentOverdueBanner(
                    overdueCount: summary.overdueCount,
                    overdueAmount: summary.overdueAmount,
                    paymentItem: state is ParentPaymentsSuccess
                        ? state.history.firstWhere(
                            (e) => e.status.toLowerCase() == 'overdue',
                            orElse: () => state.history.first,
                          )
                        : null,
                  ),
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
                PaymentHistoryList(
                  showAllHistory: _showAllHistory,
                  history: state is ParentPaymentsSuccess ? state.history : [],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PaymentSummaryModel _getMockSummary() {
    return PaymentSummaryModel(
      totalPaid: 10000,
      pending: 500,
      overdue: 200,
      totalDue: 700,
      overdueCount: 1,
      overdueAmount: 200,
      totalChildren: 2,
      totalInvoices: 5,
      hasOverduePayments: true,
      minimumPaymentDue: 200,
    );
  }
}
