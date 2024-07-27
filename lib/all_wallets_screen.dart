import 'package:flutter/material.dart';
import 'models.dart';
import 'data_loader.dart';
import 'wallet_detail.dart';
import 'add_wallet_screen.dart'; // Import the AddWalletScreen component

class AllWalletsScreen extends StatefulWidget {
  const AllWalletsScreen({super.key});

  @override
  State<AllWalletsScreen> createState() => _AllWalletsScreenState();
}

class _AllWalletsScreenState extends State<AllWalletsScreen> {
  late Future<List<Wallet>> futureWallets;

  @override
  void initState() {
    super.initState();
    futureWallets = loadWallets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Wallets'),
      ),
      body: FutureBuilder<List<Wallet>>(
        future: futureWallets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            List<Wallet> wallets = snapshot.data!;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2,
              ),
              itemCount: wallets.length + 1, // Add one more for the "Create Wallet" button
              itemBuilder: (context, index) {
                if (index == 0) {
                  // First item is the "Create Wallet" button
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddWalletScreen(),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      color: Colors.white10, // Different color for the button
                      child: Center(
                        child: Text(
                          'Create Wallet',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Display existing wallets
                  Wallet wallet = wallets[index - 1]; // Adjust index for wallet list
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WalletDetail(wallet: wallet),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      color: Colors.white, // Matching color with existing wallets
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(wallet.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text('\$${wallet.amount}', style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
