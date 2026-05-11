import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:school_system/core/utils/app_constants.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/data/models/payment_history_model.dart';
import 'package:school_system/features/parent/data/models/payment_request_model.dart';
import 'package:school_system/features/parent/presentation/manager/parent_pay_cubit/parent_pay_cubit.dart';
import 'package:school_system/features/parent/presentation/manager/parent_pay_cubit/parent_pay_state.dart';
import 'package:school_system/features/parent/presentation/views/parent_receipt_view.dart';

// Widgets
import 'payment_method_selector.dart';
import 'payment_total_amount_card.dart';
import 'payment_action_buttons.dart';
import 'payment_footer_icons.dart';

class ParentSecurePaymentViewBody extends StatefulWidget {
  final PaymentHistoryItemModel? paymentItem;
  const ParentSecurePaymentViewBody({super.key, this.paymentItem});

  @override
  State<ParentSecurePaymentViewBody> createState() =>
      _ParentSecurePaymentViewBodyState();
}

class _ParentSecurePaymentViewBodyState
    extends State<ParentSecurePaymentViewBody> {
  String _selectedMethod = 'paypal';

  @override
  Widget build(BuildContext context) {
    if (widget.paymentItem == null) {
      return const Center(child: Text('No payment information available.'));
    }

    return BlocListener<ParentPayCubit, ParentPayState>(
      listener: (context, state) {
        if (state is ParentPaySuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.response.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(
            context,
            ParentReceiptView.routeName,
            arguments: state.response.receiptNumber,
          );
        } else if (state is ParentFawaterkPaySuccess) {
          final response = state.response;
          if (response.fawryCode != null && response.fawryCode!.isNotEmpty) {
            _showFawryCodeDialog(
              response.fawryCode!,
              response.expireDate ?? 'N/A',
              onDone: () => Navigator.pushReplacementNamed(
                context,
                ParentReceiptView.routeName,
                arguments: response.invoiceId.toString(),
              ),
            );
          } else if (response.redirectTo != null &&
              response.redirectTo!.isNotEmpty) {
            _showRedirectDialog(
              response.redirectTo!,
              onDone: () => Navigator.pushReplacementNamed(
                context,
                ParentReceiptView.routeName,
                arguments: response.invoiceId.toString(),
              ),
            );
          } else if (response.meezaReference != null) {
            _showMeezaDialog(
              response.meezaReference.toString(),
              onDone: () => Navigator.pushReplacementNamed(
                context,
                ParentReceiptView.routeName,
                arguments: response.invoiceId.toString(),
              ),
            );
          }
        } else if (state is ParentPayFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Secure Payment',
              style: AppTextStyle.bold24.copyWith(
                color: const Color(0xFF1A1D1E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete your transaction securely using our encrypted gateway.',
              style: AppTextStyle.medium12.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 24),
            PaymentMethodSelector(
              selectedMethod: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val),
            ),
            const SizedBox(height: 24),
            PaymentTotalAmountCard(
              amount: widget.paymentItem?.remainingAmount.toDouble() ?? 0.0,
            ),
            const SizedBox(height: 24),
            PaymentActionButtons(
              onCancelPressed: () => Navigator.pop(context),
              onPayPressed: () {
                if (_selectedMethod == 'paypal') {
                  _launchPaypalCheckout(context);
                } else {
                  _launchFawaterkCheckout(
                    context,
                    int.tryParse(_selectedMethod) ?? 3,
                  );
                }
              },
            ),
            const SizedBox(height: 32),
            const PaymentFooterIcons(),
          ],
        ),
      ),
    );
  }

  void _launchPaypalCheckout(BuildContext parentContext) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: true,
          clientId: AppConstants.paypalClientId,
          secretKey: AppConstants.paypalSecretKey,
          transactions: [
            {
              "amount": {
                "total": widget.paymentItem!.remainingAmount.toStringAsFixed(2),
                "currency": "USD",
                "details": {
                  "subtotal": widget.paymentItem!.remainingAmount
                      .toStringAsFixed(2),
                  "shipping": '0',
                  "shipping_discount": 0,
                },
              },
              "description": widget.paymentItem!.title,
              "item_list": {
                "items": [
                  {
                    "name": widget.paymentItem!.title,
                    "quantity": 1,
                    "price": widget.paymentItem!.remainingAmount
                        .toStringAsFixed(2),
                    "currency": "USD",
                  },
                ],
              },
            },
          ],
          note: "Payment for ${widget.paymentItem!.studentName}",
          onSuccess: (Map params) async {
            Navigator.pop(context); // Close PayPal webview

            // Call backend API to record the transaction
            // We pass dummy card data since PayPal handled the actual payment
            parentContext.read<ParentPayCubit>().processPayment(
              PaymentRequestModel(
                invoiceId: widget.paymentItem!.invoiceId,
                studentId: widget.paymentItem!.studentId,
                amount: widget.paymentItem!.remainingAmount,
                cardNumber: "0000 0000 0000 0000",
                expiryDate: "12/25",
                cvv: "000",
                cardholderName: "PayPal Transaction",
                email: "paypal_user@example.com",
                phone: "0000000000",
              ),
            );
          },
          onError: (error) {
            Navigator.pop(context);
            ScaffoldMessenger.of(parentContext).showSnackBar(
              SnackBar(
                content: Text("PayPal Error: $error"),
                backgroundColor: Colors.red,
              ),
            );
          },
          onCancel: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              parentContext,
            ).showSnackBar(const SnackBar(content: Text("Payment cancelled")));
          },
        ),
      ),
    );
  }

  void _launchFawaterkCheckout(
    BuildContext parentContext,
    int paymentMethodId,
  ) {
    // We send the selected payment method ID to the backend/repo
    parentContext.read<ParentPayCubit>().processFawaterkPayment(
      PaymentRequestModel(
        invoiceId: widget.paymentItem!.invoiceId,
        studentId: widget.paymentItem!.studentId,
        amount: widget.paymentItem!.remainingAmount,
        cardNumber: paymentMethodId
            .toString(), // Quick hack to pass payment method to Repo
        expiryDate: "12/99",
        cvv: "000",
        cardholderName: "Fawaterk Checkout",
        email: "fawaterk@example.com",
        phone: "0000000000",
      ),
    );
  }

  void _showFawryCodeDialog(
    String fawryCode,
    String expireDate, {
    required VoidCallback onDone,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.storefront, color: Colors.amber.shade700, size: 28),
            const SizedBox(width: 8),
            const Text('Fawry Reference Code'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Please pay the exact amount at any Fawry kiosk or using the Fawry app using the following reference code:',
              style: AppTextStyle.medium14.copyWith(
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                border: Border.all(color: Colors.amber.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                fawryCode,
                style: AppTextStyle.bold24.copyWith(
                  letterSpacing: 2.0,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Expires on: $expireDate',
              style: AppTextStyle.bold12.copyWith(color: Colors.red.shade400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              onDone(); // Dynamic action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Done',
              style: AppTextStyle.bold14.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showRedirectDialog(String url, {required VoidCallback onDone}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Complete Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please complete your payment via the secure link:'),
            const SizedBox(height: 16),
            SelectableText(url, style: const TextStyle(color: Colors.blue)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDone();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showMeezaDialog(String reference, {required VoidCallback onDone}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Meeza Reference'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please use the following reference for Meeza:'),
            const SizedBox(height: 16),
            SelectableText(
              reference,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDone();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
