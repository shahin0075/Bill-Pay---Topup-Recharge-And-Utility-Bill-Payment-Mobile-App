class BillDetail {
  dynamic date;
  dynamic billMethod;
  dynamic paymentGateway;
  dynamic transactionId;
  dynamic status;
  dynamic exchangeRate;
  dynamic baseCurrency;
  dynamic baseCurrencySymbol;
  dynamic paymentCurrency;
  dynamic payInBase;
  dynamic category;
  dynamic type;
  List<dynamic> customers;
  dynamic countryCode;
  dynamic amount;
  dynamic charge;
  dynamic payableAmount;

  BillDetail({
    required this.date,
    required this.billMethod,
    required this.paymentGateway,
    required this.transactionId,
    required this.status,
    required this.exchangeRate,
    required this.baseCurrency,
    required this.baseCurrencySymbol,
    required this.paymentCurrency,
    required this.payInBase,
    required this.category,
    required this.type,
    required this.customers,
    required this.countryCode,
    required this.amount,
    required this.charge,
    required this.payableAmount,
  });

  factory BillDetail.fromJson(Map<String, dynamic> json) {
    var customerList = json['customers'] as List<dynamic>;
    List<Customer> customers = customerList.map((customer) => Customer.fromJson(customer)).toList();

    return BillDetail(
      date: json['date'],
      billMethod: json['billMethod'],
      paymentGateway: json['paymentGateway'],
      transactionId: json['transactionId'],
      status: json['status'],
      exchangeRate: json['exchangeRate'],
      baseCurrency: json['baseCurrency'],
      baseCurrencySymbol: json['baseCurrencySymbol'],
      paymentCurrency: json['paymentCurrency'],
      payInBase: json['payInBase'],
      category: json['category'],
      type: json['type'],
      customers: customers,
      countryCode: json['countryCode'],
      amount: json['amount'],
      charge: json['charge'],
      payableAmount: json['payableAmount'],
    );
  }
}

class Customer {
  dynamic fieldName;
  dynamic fieldValue;

  Customer({
    required this.fieldName,
    required this.fieldValue,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      fieldName: json['fieldName'],
      fieldValue: json['fieldValue'],
    );
  }
}
