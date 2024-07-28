import 'package:flutter/material.dart';
import 'models.dart';
import 'data_loader.dart';

class AllBanksScreen extends StatelessWidget {
  const AllBanksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Banks'),
      ),
      body: FutureBuilder<List<BankAccount>>(
        future: loadBankAccounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            List<BankAccount> banks = snapshot.data!;
            return ListView.builder(
              itemCount: banks.length,
              itemBuilder: (context, index) {
                BankAccount bank = banks[index];
                return ListTile(
                  title: Text(bank.name),
                  subtitle: Text('Balance: \$${bank.balance}'),
                  onTap: () {
                    // Handle bank detail navigation
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
