import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod; // 'paypal' or '3' (Fawry)
  final ValueChanged<String> onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputLabel('PAYMENT METHOD'),
          _buildOption(
            title: 'PayPal',
            value: 'paypal',
            icon: Icons.paypal,
            color: AppColors.secondaryColor,
          ),
          const SizedBox(height: 12),
          _buildOption(
            title: 'Fawry',
            value: '3', // Fawry ID in Fawaterk
            icon: Icons.account_balance_wallet,
            color: Colors.amber.shade700,
          ),
          const SizedBox(height: 16),
          Text(
            selectedMethod == 'paypal'
                ? 'You will be redirected to PayPal to complete your purchase securely.'
                : 'You will receive a Fawry reference code to pay at any supported kiosk.',
            style: AppTextStyle.medium12.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = selectedMethod == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F4FF) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.secondaryColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppTextStyle.bold16.copyWith(
                color: isSelected ? AppColors.secondaryColor : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.secondaryColor)
            else
              Icon(Icons.circle_outlined, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        label,
        style: AppTextStyle.bold12.copyWith(
          color: Colors.grey.shade700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
