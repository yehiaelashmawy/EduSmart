class FawaterkPaymentMethodModel {
  final int paymentId;
  final String nameEn;
  final String nameAr;
  final String redirect;
  final String logo;

  FawaterkPaymentMethodModel({
    required this.paymentId,
    required this.nameEn,
    required this.nameAr,
    required this.redirect,
    required this.logo,
  });

  factory FawaterkPaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return FawaterkPaymentMethodModel(
      paymentId: json['paymentId'] ?? 0,
      nameEn: json['name_en'] ?? '',
      nameAr: json['name_ar'] ?? '',
      redirect: json['redirect'] ?? 'false',
      logo: json['logo'] ?? '',
    );
  }
}
