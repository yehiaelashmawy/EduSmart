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

class _ParentSecurePaymentViewBodyState extends State<ParentSecurePaymentViewBody> {
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
            const PaymentMethodSelector(),
            const SizedBox(height: 24),
            PaymentTotalAmountCard(
              amount: widget.paymentItem?.remainingAmount.toDouble() ?? 0.0,
            ),
            const SizedBox(height: 24),
            PaymentActionButtons(
              onCancelPressed: () => Navigator.pop(context),
              onPayPressed: () => _launchPaypalCheckout(context),
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
                  "subtotal": widget.paymentItem!.remainingAmount.toStringAsFixed(2),
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": widget.paymentItem!.title,
              "item_list": {
                "items": [
                  {
                    "name": widget.paymentItem!.title,
                    "quantity": 1,
                    "price": widget.paymentItem!.remainingAmount.toStringAsFixed(2),
                    "currency": "USD"
                  }
                ]
              }
            }
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
              SnackBar(content: Text("PayPal Error: $error"), backgroundColor: Colors.red),
            );
          },
          onCancel: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(parentContext).showSnackBar(
              const SnackBar(content: Text("Payment cancelled")),
            );
          },
        ),
      ),
    );
  }
}
