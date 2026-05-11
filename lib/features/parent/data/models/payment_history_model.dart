class PaymentHistoryItemModel {
  final String invoiceId;
  final String invoiceNumber;
  final String title;
  final String category;
  final double amount;
  final double paidAmount;
  final double remainingAmount;
  final String dueDate;
  final String status;
  final String? paidDate;
  final String? receiptNumber;
  final String studentName;
  final String studentId;
  final bool canPay;
  final bool isOverdue;
  final int daysOverdue;

  PaymentHistoryItemModel({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.title,
    required this.category,
    required this.amount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.dueDate,
    required this.status,
    this.paidDate,
    this.receiptNumber,
    required this.studentName,
    required this.studentId,
    required this.canPay,
    required this.isOverdue,
    required this.daysOverdue,
  });

  factory PaymentHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryItemModel(
      invoiceId: json['invoiceId'] ?? '',
      invoiceNumber: json['invoiceNumber'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
      remainingAmount: (json['remainingAmount'] as num?)?.toDouble() ?? 0.0,
      dueDate: json['dueDate'] ?? '',
      status: json['status'] ?? '',
      paidDate: json['paidDate'],
      receiptNumber: json['receiptNumber'],
      studentName: json['studentName'] ?? '',
      studentId: json['studentId'] ?? '',
      canPay: json['canPay'] ?? false,
      isOverdue: json['isOverdue'] ?? false,
      daysOverdue: json['daysOverdue'] ?? 0,
    );
  }
}

class PaymentHistoryResponseModel {
  final List<PaymentHistoryItemModel> items;
  final int totalCount;
  final int page;
  final int pageSize;

  PaymentHistoryResponseModel({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  factory PaymentHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryResponseModel(
      items: (json['items'] as List? ?? [])
          .map((e) => PaymentHistoryItemModel.fromJson(e))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
    );
  }
}
