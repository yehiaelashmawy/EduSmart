class FawaterkPaymentResponseModel {
  final String status;
  final int invoiceId;
  final String invoiceKey;
  final String? fawryCode;
  final String? expireDate;
  final String? redirectTo;
  final int? meezaReference;

  FawaterkPaymentResponseModel({
    required this.status,
    required this.invoiceId,
    required this.invoiceKey,
    this.fawryCode,
    this.expireDate,
    this.redirectTo,
    this.meezaReference,
  });

  factory FawaterkPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final paymentData = data['payment_data'] ?? {};
    return FawaterkPaymentResponseModel(
      status: json['status'] ?? '',
      invoiceId: data['invoice_id'] ?? 0,
      invoiceKey: data['invoice_key'] ?? '',
      fawryCode: paymentData['fawryCode'],
      expireDate: paymentData['expireDate'],
      redirectTo: paymentData['redirectTo'],
      meezaReference: paymentData['meezaReference'],
    );
  }
}
