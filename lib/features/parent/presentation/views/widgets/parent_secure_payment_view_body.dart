import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/data/models/payment_history_model.dart';
import 'package:school_system/features/parent/data/models/payment_request_model.dart';
import 'package:school_system/features/parent/presentation/manager/parent_pay_cubit/parent_pay_cubit.dart';
import 'package:school_system/features/parent/presentation/manager/parent_pay_cubit/parent_pay_state.dart';
import 'package:school_system/features/parent/presentation/views/parent_receipt_view.dart';

class ParentSecurePaymentViewBody extends StatefulWidget {
  final PaymentHistoryItemModel? paymentItem;
  const ParentSecurePaymentViewBody({super.key, this.paymentItem});

  @override
  State<ParentSecurePaymentViewBody> createState() => _ParentSecurePaymentViewBodyState();
}

class _ParentSecurePaymentViewBodyState extends State<ParentSecurePaymentViewBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
            _buildPaymentForm(),
            const SizedBox(height: 24),
            _buildContactForm(),
            const SizedBox(height: 24),
            _buildTotalAmountCard(),
            const SizedBox(height: 24),
            _buildActionButtons(context),
            const SizedBox(height: 32),
            _buildFooterIcons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.lock_outline,
              size: 48,
              color: Colors.grey.shade100,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputLabel('CARDHOLDER NAME'),
              _buildTextField(
                controller: _nameController,
                hint: 'e.g. Sarah Jenkins',
              ),
              const SizedBox(height: 16),
              _buildInputLabel('CARD NUMBER'),
              _buildTextField(
                controller: _cardNumberController,
                hint: '0000 0000 0000 0000',
                suffixIcon: Icons.credit_card,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel('EXPIRY DATE'),
                        _buildTextField(
                          controller: _expiryDateController,
                          hint: 'MM / YY',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel('CVV'),
                        _buildTextField(
                          controller: _cvvController,
                          hint: '***',
                          keyboardType: TextInputType.number,
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
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
          _buildInputLabel('EMAIL ADDRESS'),
          _buildTextField(
            controller: _emailController,
            hint: 'e.g. sarah.jenkins@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildInputLabel('PHONE NUMBER'),
          _buildTextField(
            controller: _phoneController,
            hint: 'e.g. 01063977686',
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: AppTextStyle.bold12.copyWith(
          color: Colors.grey.shade700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    IconData? suffixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyle.medium14.copyWith(
            color: Colors.grey.shade400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: Colors.grey.shade400, size: 20)
              : null,
        ),
      ),
    );
  }

  Widget _buildTotalAmountCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL AMOUNT',
                style: AppTextStyle.bold12.copyWith(
                  color: AppColors.secondaryColor,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${widget.paymentItem?.remainingAmount.toStringAsFixed(2) ?? '0.00'}',
                style: AppTextStyle.bold36.copyWith(
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.verified, color: AppColors.secondaryColor, size: 14),
                const SizedBox(width: 4),
                Text(
                  'BANK GRADE SECURITY',
                  style: AppTextStyle.bold12.copyWith(
                    color: AppColors.secondaryColor,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,
            ),
            child: Text(
              'Cancel',
              style: AppTextStyle.bold16.copyWith(
                color: AppColors.secondaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: BlocBuilder<ParentPayCubit, ParentPayState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state is ParentPayLoading
                    ? null
                    : () {
                        if (_validateInputs()) {
                          context.read<ParentPayCubit>().processPayment(
                                PaymentRequestModel(
                                  invoiceId: widget.paymentItem!.invoiceId,
                                  studentId: widget.paymentItem!.studentId,
                                  amount: widget.paymentItem!.remainingAmount,
                                  cardNumber: _cardNumberController.text,
                                  expiryDate: _expiryDateController.text,
                                  cvv: _cvvController.text,
                                  cardholderName: _nameController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                ),
                              );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: state is ParentPayLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pay Now',
                            style: AppTextStyle.bold16.copyWith(color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                        ],
                      ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty ||
        _cardNumberController.text.isEmpty ||
        _expiryDateController.text.isEmpty ||
        _cvvController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return false;
    }
    return true;
  }

  Widget _buildFooterIcons() {
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
