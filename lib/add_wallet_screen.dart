import 'package:flutter/material.dart';
import 'models.dart'; // Ensure you have the Wallet model imported
import 'data_loader.dart'; // Import your data loader

class AddWalletScreen extends StatefulWidget {
  const AddWalletScreen({super.key});

  @override
  _AddWalletScreenState createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = '0'; // Set initial amount to 0 and make it non-editable
    _generateAccountNumber(); // Generate account number when the screen is initialized
  }

  void _generateAccountNumber() async {
    final wallets = await loadWallets();
    final int newAccountNumber = wallets.isNotEmpty
        ? (wallets.map((w) => w.account).reduce((a, b) => a > b ? a : b) + 1)
        : 1;
    _accountController.text = newAccountNumber.toString();
  }

  void _addWallet() {
    if (_formKey.currentState?.validate() ?? false) {
      final String name = _nameController.text;
      final int account = int.tryParse(_accountController.text) ?? 0; // Convert to int
      final double amount = double.tryParse(_amountController.text) ?? 0.0;

      // Create a new Wallet instance
      final Wallet newWallet = Wallet(
        name: name,
        account: account, // Use int
        amount: amount,
        transactions: [], // Set transactions to empty list
      );

      // Save the new wallet
      saveWallet(newWallet); // Implement this method in your data_loader.dart

      // Go back to the home screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Wallet Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a wallet name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _accountController,
                decoration: const InputDecoration(labelText: 'Account Number'),
                keyboardType: TextInputType.number,
                enabled: false, // Disable editing for account number
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Account number is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Initial Amount'),
                keyboardType: TextInputType.number,
                enabled: false, // Disable editing for amount
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Initial amount is required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addWallet,
                child: const Text('Add Wallet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
