import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/presentation/views/parent_secure_payment_view.dart';

class PaymentOverdueBanner extends StatelessWidget {
  const PaymentOverdueBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFDADA)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFC62828),
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
}
