import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class ParentReceiptView extends StatelessWidget {
  static const routeName = 'parent_receipt_view';

  const ParentReceiptView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        titleSpacing: 12,
        title: Text(
          'Receipt',
          style: AppTextStyle.bold20.copyWith(color: AppColors.secondaryColor),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFFF8F9FC),
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.secondaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildTopBanner(),
            const SizedBox(height: 16),
            _buildReceiptCard(),
            const SizedBox(height: 24),
            _buildHelpCard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor, // Dark blue
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LAST PAYMENT DATE',
                style: AppTextStyle.bold12.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Oct 24, 2023',
                style: AppTextStyle.bold24.copyWith(color: Colors.white),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.calendar_today, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blue top border
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tuition Fee Q1',
                      style: AppTextStyle.bold24.copyWith(
                        color: const Color(0xFF1A1D1E),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'PAID',
                        style: AppTextStyle.bold12.copyWith(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Transaction ID:\n#SCH-8829-012',
                  style: AppTextStyle.medium14.copyWith(
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                _buildDetailRow(
                  icon: Icons.payments_outlined,
                  title: 'Amount',
                  value: '\$450.00',
                ),
                const SizedBox(height: 24),
                _buildDetailRow(
                  icon: Icons.calendar_month_outlined,
                  title: 'Date',
                  value: 'Oct 15, 2023',
                ),
                const SizedBox(height: 24),
                _buildDetailRow(
                  icon: Icons.credit_card_outlined,
                  title: 'Payment Method',
                  value: 'Visa **** 1234',
                ),
                const SizedBox(height: 24),
                _buildDetailRow(
                  icon: Icons.person_outline, // Ideally an avatar image
                  title: 'Child\'s Name',
                  value: 'Alexander Wright',
                  isAvatar: true,
                ),
                const SizedBox(height: 32),
                // Dotted Divider
                Row(
                  children: List.generate(
                    30,
                    (index) => Expanded(
                      child: Container(
                        color: index % 2 == 0
                            ? Colors.grey.shade300
                            : Colors.transparent,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(
                      icon: Icons.download_outlined,
                      label: 'Download',
                    ),
                    _buildActionButton(
                      icon: Icons.print_outlined,
                      label: 'Print',
                    ),
                    _buildActionButton(
                      icon: Icons.email_outlined,
                      label: 'Email',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    bool isAvatar = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            image: isAvatar
                ? const DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: !isAvatar
              ? Icon(icon, color: AppColors.secondaryColor, size: 24)
              : null,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyle.bold12.copyWith(color: Colors.grey.shade500),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyle.bold16.copyWith(
                color: const Color(0xFF1A1D1E),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required String label}) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.secondaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyle.bold12.copyWith(
              color: AppColors.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.help_outline,
              color: AppColors.secondaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need help with this?',
                  style: AppTextStyle.bold16.copyWith(
                    color: const Color(0xFF1A1D1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Contact our bursar office for payment inquiries.',
                  style: AppTextStyle.medium14.copyWith(
                    color: Colors.grey.shade700,
                    height: 1.5,
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
