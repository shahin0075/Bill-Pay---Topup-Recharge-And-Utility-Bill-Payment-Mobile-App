class BillRequest {
  final dynamic date;
  final dynamic trxNumber;
  final dynamic method;
  final dynamic amount;
  final dynamic charge;
  final dynamic currency;
  final dynamic currencySymbol;
  final dynamic payable;
  final dynamic payableCurrency;
  final dynamic rejectedCause; // It can be nullable
  final dynamic status;

  BillRequest({
    required this.date,
    required this.trxNumber,
    required this.method,
    required this.amount,
    required this.charge,
    required this.currency,
    required this.currencySymbol,
    required this.payable,
    required this.payableCurrency,
    required this.rejectedCause,
    required this.status,
  });

  factory BillRequest.fromJson(Map<String, dynamic> json) {
    return BillRequest(
      date: json['date'],
      trxNumber: json['trxNumber'],
      method: json['method'],
      amount: json['amount'],
      charge: json['charge'],
      currency: json['currency'],
      currencySymbol: json['currencySymbol'],
      payable: json['payable'],
      payableCurrency: json['payableCurrency'],
      rejectedCause: json['rejectedCause'],
      status: json['status'],
    );
  }
}
