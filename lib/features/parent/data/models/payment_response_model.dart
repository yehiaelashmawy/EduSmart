class PaymentResponseModel {
  final bool success;
  final String message;
  final String receiptNumber;
  final String transactionId;
  final String paymentDate;
  final num amountPaid;
  final num remainingAmount;
  final bool isFullyPaid;
  final String invoiceNumber;
  final String studentName;

  PaymentResponseModel({
    required this.success,
    required this.message,
    required this.receiptNumber,
    required this.transactionId,
    required this.paymentDate,
    required this.amountPaid,
    required this.remainingAmount,
    required this.isFullyPaid,
    required this.invoiceNumber,
    required this.studentName,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      receiptNumber: json['receiptNumber'] ?? '',
      transactionId: json['transactionId'] ?? '',
      paymentDate: json['paymentDate'] ?? '',
      amountPaid: json['amountPaid'] ?? 0,
      remainingAmount: json['remainingAmount'] ?? 0,
      isFullyPaid: json['isFullyPaid'] ?? false,
      invoiceNumber: json['invoiceNumber'] ?? '',
      studentName: json['studentName'] ?? '',
    );
  }
}
