class Transaction {
  final String transactionId;
  final double amount;
  final String currency;
  final String symbol;
  final String type;
  final String remarks;
  final String status;
  final String time;

  Transaction({
    required this.transactionId,
    required this.amount,
    required this.currency,
    required this.symbol,
    required this.type,
    required this.remarks,
    required this.status,
    required this.time,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transactionId'],
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      symbol: json['symbol'],
      type: json['type'],
      remarks: json['remarks'],
      status: json['status'],
      time: json['time'],
    );
  }
}
