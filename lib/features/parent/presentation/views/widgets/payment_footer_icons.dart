import 'package:flutter/material.dart';

class PaymentFooterIcons extends StatelessWidget {
  const PaymentFooterIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.money, color: Colors.grey.shade400, size: 32),
        const SizedBox(width: 24),
        Icon(Icons.account_balance, color: Colors.grey.shade400, size: 32),
        const SizedBox(width: 24),
        Icon(Icons.contactless_outlined, color: Colors.grey.shade400, size: 32),
      ],
    );
  }
}
