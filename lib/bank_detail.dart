import 'package:flutter/material.dart';
import 'models.dart';

class BankDetail extends StatelessWidget {
  final BankAccount bank;

  const BankDetail({Key? key, required this.bank}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bank.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account Number: ${bank.accountNumber}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Balance: \$${bank.balance}', style: const TextStyle(fontSize: 18)),
            // Add more details or actions related to the bank account here
          ],
        ),
      ),
    );
  }
}
