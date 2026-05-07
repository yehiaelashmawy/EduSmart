class ActiveSessionModel {
  final String sessionId;
  final String className;
  final int method;
  final String? qrCodeBase64;
  final List<int>? randomNumbers;
  final String expiresAt;

  ActiveSessionModel({
    required this.sessionId,
    required this.className,
    required this.method,
    this.qrCodeBase64,
    this.randomNumbers,
    required this.expiresAt,
  });

  factory ActiveSessionModel.fromJson(Map<String, dynamic> json) {
    return ActiveSessionModel(
      sessionId: json['sessionId'] as String? ?? '',
      className: json['className'] as String? ?? '',
      method: json['method'] as int? ?? 1,
      qrCodeBase64: json['qrCodeBase64'] as String?,
      randomNumbers: (json['randomNumbers'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      expiresAt: json['expiresAt'] as String? ?? '',
    );
  }
}
