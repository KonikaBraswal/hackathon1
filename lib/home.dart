import 'package:flutter/material.dart';
import 'models.dart';
import 'data_loader.dart';
import 'wallet_detail.dart';
import 'all_wallets_screen.dart'; // Import the new screen
import 'add_wallet_screen.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Wallet>> futureWallets;

  @override
  void initState() {
    super.initState();
    futureWallets = loadWallets();
  }

  void _createWallet() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddWalletScreen()),
    );
  }


  void _viewAll() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllWalletsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallets'),
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

            // Limit wallets to 4 for display purposes
            List<Wallet> displayedWallets = wallets.take(4).toList();
            bool hasMoreWallets = wallets.length > 4;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2,
              ),
              itemCount: (hasMoreWallets ? displayedWallets.length + 2 : displayedWallets.length + 1),
              itemBuilder: (context, index) {
                if (index == 0) {
                  // The first item is the "Create Wallet" button
                  return GestureDetector(
                    onTap: _createWallet,
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      color: Colors.white, // Match color with existing wallets
                      child: Center(
                        child: Text(
                          'Create Wallet',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  );
                } else if (index == displayedWallets.length + 1 && hasMoreWallets) {
                  // The last item is the "View All" button if there are more than 4 wallets
                  return GestureDetector(
                    onTap: _viewAll,
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      color: Colors.white, // Match color with existing wallets
                      child: Center(
                        child: Text(
                          'All Wallets',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Display existing wallets
                  Wallet wallet = displayedWallets[index - 1]; // Adjust index for wallet list
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
                      color: Colors.white, // Match color with existing wallets
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(wallet.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text('Amount: \$${wallet.amount}', style: const TextStyle(fontSize: 16)),
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
