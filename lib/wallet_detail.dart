import 'package:flutter/material.dart';
import 'home.dart'; // Import the home.dart file
import 'models.dart';
import 'data_loader.dart'; // Import the data_loader to use the deleteWallet method

class WalletDetail extends StatefulWidget {
  final Wallet wallet;

  const WalletDetail({super.key, required this.wallet});

  @override
  _WalletDetailState createState() => _WalletDetailState();
}

class _WalletDetailState extends State<WalletDetail> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        // Navigate to the home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()), // Replace with your Home widget
        );
      } else if (index == 1) {
        // Trigger the make payment functionality
        _makePayment(context);
      }
    });
  }

  void _makePayment(BuildContext context) {
    // Implement your make payment functionality here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Make Payment button pressed')),
    );
  }

  Future<void> _deleteWallet() async {
    if (widget.wallet.amount > 0) {
      // Show an AlertDialog if the wallet cannot be deleted
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Cannot Delete Wallet'),
            content: const Text('You can only delete wallets with an amount of zero.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Confirm deletion
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this wallet?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await deleteWallet(widget.wallet); // Call deleteWallet from data_loader.dart
      Navigator.pop(context); // Return to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.wallet.name} Wallet'),
        actions: [
          if (widget.wallet.amount == 0) // Show delete icon only if amount is zero
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteWallet,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account: ${widget.wallet.account}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Name: ${widget.wallet.name}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Amount: \$${widget.wallet.amount}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text('Transactions:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.wallet.transactions.length,
                itemBuilder: (context, index) {
                  Transaction transaction = widget.wallet.transactions[index];
                  return ListTile(
                    title: Text(transaction.description),
                    subtitle: Text(transaction.date),
                    trailing: Text('\$${transaction.amount}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'My Wallets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Make Payment',
          ),
        ],
      ),
    );
  }
}
