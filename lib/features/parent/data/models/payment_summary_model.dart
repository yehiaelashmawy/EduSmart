class PaymentSummaryModel {
  final double totalPaid;
  final double pending;
  final double overdue;
  final double totalDue;
  final int overdueCount;
  final double overdueAmount;
  final int totalChildren;
  final int totalInvoices;
  final bool hasOverduePayments;
  final double minimumPaymentDue;

  PaymentSummaryModel({
    required this.totalPaid,
    required this.pending,
    required this.overdue,
    required this.totalDue,
    required this.overdueCount,
    required this.overdueAmount,
    required this.totalChildren,
    required this.totalInvoices,
    required this.hasOverduePayments,
    required this.minimumPaymentDue,
  });

  factory PaymentSummaryModel.fromJson(Map<String, dynamic> json) {
    return PaymentSummaryModel(
      totalPaid: (json['totalPaid'] as num?)?.toDouble() ?? 0.0,
      pending: (json['pending'] as num?)?.toDouble() ?? 0.0,
      overdue: (json['overdue'] as num?)?.toDouble() ?? 0.0,
      totalDue: (json['totalDue'] as num?)?.toDouble() ?? 0.0,
      overdueCount: json['overdueCount'] ?? 0,
      overdueAmount: (json['overdueAmount'] as num?)?.toDouble() ?? 0.0,
      totalChildren: json['totalChildren'] ?? 0,
      totalInvoices: json['totalInvoices'] ?? 0,
      hasOverduePayments: json['hasOverduePayments'] ?? false,
      minimumPaymentDue: (json['minimumPaymentDue'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
