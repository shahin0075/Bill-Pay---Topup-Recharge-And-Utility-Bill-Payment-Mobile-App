class TwoFactorModel {
  final bool twoFactorEnable;
  final String secret;
  final String qrCodeUrl;
  final String? previousCode;
  final String? previousQR;
  final String downloadApp;
  final String downloadAppIOS;

  TwoFactorModel({
    required this.twoFactorEnable,
    required this.secret,
    required this.qrCodeUrl,
    this.previousCode,
    this.previousQR,
    required this.downloadApp,
    required this.downloadAppIOS,
  });

  factory TwoFactorModel.fromJson(Map<String, dynamic> json) {
    return TwoFactorModel(
      twoFactorEnable: json['twoFactorEnable'],
      secret: json['secret'],
      qrCodeUrl: json['qrCodeUrl'],
      previousCode: json['previousCode'],
      previousQR: json['previousQR'],
      downloadApp: json['downloadApp'],
      downloadAppIOS: json['downloadAppIOS'],
    );
  }
}

class ApiResponse {
  final String status;
  final TwoFactorModel message;

  ApiResponse({
    required this.status,
    required this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      message: TwoFactorModel.fromJson(json['message']),
    );
  }
}
