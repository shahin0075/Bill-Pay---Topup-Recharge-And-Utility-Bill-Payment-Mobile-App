class PaymentMethod {
  final String imageUrl;
  final String name;
  bool isActive;

  PaymentMethod({
    required this.imageUrl,
    required this.name,
    this.isActive = false,
  });
}

class ApiResponse {
  final String status;
  final BillPreview message;

  ApiResponse({required this.status, required this.message});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      message: BillPreview.fromJson(json['message']),
    );
  }
}

class BillPreview {
  final int id;
  final String utr;
  final String category;
  final String service;
  final String countryCode;
  final double amount;
  final String currency;
  final double charge;
  final double exchangeRate;
  final List<Gateway> gateways;

  BillPreview({
    required this.id,
    required this.utr,
    required this.category,
    required this.service,
    required this.countryCode,
    required this.amount,
    required this.currency,
    required this.charge,
    required this.exchangeRate,
    required this.gateways,
  });

  factory BillPreview.fromJson(Map<String, dynamic> json) {
    var gatewayList = (json['gateways'] as List).map((gateway) => Gateway.fromJson(gateway)).toList();

    return BillPreview(
      id: json['id'],
      utr: json['utr'],
      category: json['category'],
      service: json['service'],
      countryCode: json['countryCode'],
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      charge: json['charge'].toDouble(),
      exchangeRate: json['exchangeRate'].toDouble(),
      gateways: gatewayList,
    );
  }
}

class Gateway {
  final int id;
  final String image;
  final String driver;
  final String name;
  final String minAmount;
  final String maxAmount;
  final String percentageCharge;
  final String fixedCharge;
  final String conventionRate;
  final int sortBy;
  final dynamic parameters;
  final String imagePath;

  Gateway({
    required this.id,
    required this.image,
    required this.driver,
    required this.name,
    required this.minAmount,
    required this.maxAmount,
    required this.percentageCharge,
    required this.fixedCharge,
    required this.conventionRate,
    required this.sortBy,
    required this.parameters,
    required this.imagePath,
  });

  factory Gateway.fromJson(Map<String, dynamic> json) {
    return Gateway(
      id: json['id'],
      image: json['image'],
      driver: json['driver'],
      name: json['name'],
      minAmount: json['min_amount'],
      maxAmount: json['max_amount'],
      percentageCharge: json['percentage_charge'],
      fixedCharge: json['fixed_charge'],
      conventionRate: json['convention_rate'],
      sortBy: json['sort_by'],
      parameters: json['parameters'],
      imagePath: json['imagePath'],
    );
  }
}
