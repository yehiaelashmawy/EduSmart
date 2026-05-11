class PaymentRequestModel {
  final String invoiceId;
  final String studentId;
  final num amount;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String cardholderName;
  final String email;
  final String phone;

  PaymentRequestModel({
    required this.invoiceId,
    required this.studentId,
    required this.amount,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.cardholderName,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'invoiceId': invoiceId,
      'studentId': studentId,
      'amount': amount,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'cardholderName': cardholderName,
      'email': email,
      'phone': phone,
    };
  }
}
