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
    var transactionsJson = json['transactions'] as List;
    List<Transaction> transactionsList = transactionsJson.map((i) => Transaction.fromJson(i)).toList();

    return Wallet(
      account: json['account'],
      name: json['name'],
      amount: json['amount'],
      transactions: transactionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'name': name,
      'amount': amount,
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }
}

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

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'description': description,
      'amount': amount,
      'date': date,
    };
  }
}

class BankAccount {
  final int bankId;
  final String name;
  final String accountNumber;
  final double balance;

  BankAccount({
    required this.bankId,
    required this.name,
    required this.accountNumber,
    required this.balance,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      bankId: json['bank_id'],
      name: json['name'],
      accountNumber: json['account_number'],
      balance: json['balance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_id': bankId,
      'name': name,
      'account_number': accountNumber,
      'balance': balance,
    };
  }
}
