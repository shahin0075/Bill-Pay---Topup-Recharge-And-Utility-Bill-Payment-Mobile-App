class BillingCategory {
  final String key;
  final String name;
  final String image;

  BillingCategory({
    required this.key,
    required this.name,
    required this.image,
  });

  factory BillingCategory.fromJson(Map<String, dynamic> json) {
    return BillingCategory(
      key: json['key'],
      name: json['name'],
      image: json['image'],
    );
  }
}

class BillingService {
  final dynamic id;
  final dynamic billMethodId;
  final dynamic service;
  final dynamic code;
  final dynamic type;
  final dynamic country;
  final Map<String, dynamic> info;
  final List<dynamic> labelName;
  final dynamic amount;
  final dynamic percentCharge;
  final dynamic fixedCharge;
  final dynamic minAmount;
  final dynamic maxAmount;
  final dynamic currency;
  final dynamic status;
  final dynamic extraResponse;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic countryName;
  final dynamic phoneCode;

  BillingService({
    required this.id,
    required this.billMethodId,
    required this.service,
    required this.code,
    required this.type,
    required this.country,
    required this.info,
    required this.labelName,
    required this.amount,
    required this.percentCharge,
    required this.fixedCharge,
    required this.minAmount,
    required this.maxAmount,
    required this.currency,
    required this.status,
    required this.extraResponse,
    required this.createdAt,
    required this.updatedAt,
    required this.countryName,
    required this.phoneCode,
  });

  factory BillingService.fromJson(Map<String, dynamic> json) {
    return BillingService(
      id: json['id'],
      billMethodId: json['bill_method_id'],
      service: json['service'],
      code: json['code'],
      type: json['type'],
      country: json['country'],
      info: json['info'],
      labelName: List<String>.from(json['label_name']),
      amount: json['amount'],
      percentCharge: json['percent_charge'],
      fixedCharge: json['fixed_charge'],
      minAmount: json['min_amount'],
      maxAmount: json['max_amount'],
      currency: json['currency'],
      status: json['status'],
      extraResponse: json['extra_response'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      countryName: json['countryName'],
      phoneCode: json['phoneCode'],
    );
  }
}
