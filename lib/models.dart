class Transaction {
  final int transactionId;
  final String description;
  final double amount;
  final String date;

  Transaction({
    required this.transactionId,
    required this.description,
    required this.amount,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transaction_id'],
      description: json['description'],
      amount: json['amount'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() => {
    'transaction_id': transactionId,
    'description': description,
    'amount': amount,
    'date': date,
  };
}

class Wallet {
  final int account;
  final String name;
  final double amount;
  final List<Transaction> transactions;

  Wallet({
    required this.account,
    required this.name,
    required this.amount,
    required this.transactions,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    var transactionsFromJson = json['transactions'] as List;
    List<Transaction> transactionList = transactionsFromJson.map((i) => Transaction.fromJson(i)).toList();

    return Wallet(
      account: json['account'],
      name: json['name'],
      amount: json['amount'],
      transactions: transactionList,
    );
  }

  Map<String, dynamic> toJson() => {
    'account': account,
    'name': name,
    'amount': amount,
    'transactions': transactions.map((t) => t.toJson()).toList(),
  };
}
