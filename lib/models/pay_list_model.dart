class BillPayList {
  final dynamic id;
  final dynamic category;
  final dynamic type;
  final dynamic amount;
  final dynamic currency;
  final dynamic charge;
  final dynamic status;
  final dynamic date;

  BillPayList({
    required this.id,
    required this.category,
    required this.type,
    required this.amount,
    required this.currency,
    required this.charge,
    required this.status,
    required this.date,
  });

  factory BillPayList.fromJson(Map<String, dynamic> json) {
    return BillPayList(
      id: json['id'],
      category: json['category'],
      type: json['type'],
      amount: json['amount'],
      currency: json['currency'],
      charge: json['charge'],
      status: json['status'],
      date: json['date'],
    );
  }
}
