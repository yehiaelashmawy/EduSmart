class ReceiptItemModel {
  final String receiptNumber;
  final String invoiceNumber;
  final String title;
  final String category;
  final double amount;
  final String paymentDate;
  final String paymentMethod;
  final String studentName;
  final String cardLastFour;
  final String transactionId;
  final String status;

  ReceiptItemModel({
    required this.receiptNumber,
    required this.invoiceNumber,
    required this.title,
    required this.category,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    required this.studentName,
    required this.cardLastFour,
    required this.transactionId,
    required this.status,
  });

  factory ReceiptItemModel.fromJson(Map<String, dynamic> json) {
    return ReceiptItemModel(
      receiptNumber: json['receiptNumber'] ?? '',
      invoiceNumber: json['invoiceNumber'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentDate: json['paymentDate'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      studentName: json['studentName'] ?? '',
      cardLastFour: json['cardLastFour'] ?? '',
      transactionId: json['transactionId'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class ReceiptListResponseModel {
  final int totalReceipts;
  final double totalAmount;
  final String latestPaymentDate;
  final int page;
  final int pageSize;
  final List<ReceiptItemModel> items;

  ReceiptListResponseModel({
    required this.totalReceipts,
    required this.totalAmount,
    required this.latestPaymentDate,
    required this.page,
    required this.pageSize,
    required this.items,
  });

  factory ReceiptListResponseModel.fromJson(Map<String, dynamic> json) {
    return ReceiptListResponseModel(
      totalReceipts: json['totalReceipts'] ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      latestPaymentDate: json['latestPaymentDate'] ?? '',
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
      items: (json['items'] as List? ?? [])
          .map((e) => ReceiptItemModel.fromJson(e))
          .toList(),
    );
  }
}
