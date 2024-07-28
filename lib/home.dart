import 'package:flutter/material.dart';
import 'models.dart';
import 'data_loader.dart';
import 'wallet_detail.dart';
import 'all_wallets_screen.dart'; // Import the new screen
import 'add_wallet_screen.dart';
import 'add_bank_screen.dart'; // Import the screen for adding a new bank
import 'all_banks_screen.dart'; // Import the screen for viewing all banks
import 'bank_detail.dart'; // Import the BankDetail screen

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Wallet>> futureWallets;
  late Future<List<BankAccount>> futureBanks;

  @override
  void initState() {
    super.initState();
    futureWallets = loadWallets();
    futureBanks = loadBankAccounts(); // Load bank accounts
  }

  void _createWallet() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddWalletScreen()),
    );
  }

  void _viewAllWallets() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllWalletsScreen()),
    );
  }

  void _createBank() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBankScreen()),
    );
  }

  void _viewAllBanks() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllBanksScreen()),
    );
  }

  void _payFromWallet() {
    // Add your pay from wallet functionality here
  }

  void _payFromBank() {
    // Add your pay from bank functionality here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'My Wallets',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder<List<Wallet>>(
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

                  // Limit wallets to 2 for display purposes
                  List<Wallet> displayedWallets = wallets.take(2).toList();
                  bool hasMoreWallets = wallets.length > 2;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2,
                    ),
                    itemCount: hasMoreWallets ? displayedWallets.length + 2 : displayedWallets.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // The first item is the "Create Wallet" button
                        return GestureDetector(
                          onTap: _createWallet,
                          child: Card(
                            margin: const EdgeInsets.all(8.0),
                            color: Colors.white, // Match color with existing wallets
                            child: const Center(
                              child: Text(
                                'Create Wallet',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                          ),
                        );
                      } else if (index == displayedWallets.length + 1 && hasMoreWallets) {
                        // The last item is the "View All" button if there are more than 2 wallets
                        return GestureDetector(
                          onTap: _viewAllWallets,
                          child: Card(
                            margin: const EdgeInsets.all(8.0),
                            color: Colors.white, // Match color with existing wallets
                            child: const Center(
                              child: Text(
                                'All Wallets',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'My Banks',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder<List<BankAccount>>(
              future: futureBanks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  List<BankAccount> banks = snapshot.data!;

                  // Limit banks to 2 for display purposes
                  List<BankAccount> displayedBanks = banks.take(2).toList();
                  bool hasMoreBanks = banks.length > 2;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2,
                    ),
                    itemCount: hasMoreBanks ? displayedBanks.length + 2 : displayedBanks.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // The first item is the "Create Bank" button
                        return GestureDetector(
                          onTap: _createBank,
                          child: Card(
                            margin: const EdgeInsets.all(8.0),
                            color: Colors.white, // Match color with existing banks
                            child: const Center(
                              child: Text(
                                'Add Bank',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                          ),
                        );
                      } else if (index == displayedBanks.length + 1 && hasMoreBanks) {
                        // The last item is the "View All" button if there are more than 2 banks
                        return GestureDetector(
                          onTap: _viewAllBanks,
                          child: Card(
                            margin: const EdgeInsets.all(8.0),
                            color: Colors.white, // Match color with existing banks
                            child: const Center(
                              child: Text(
                                'All Banks',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                          ),
                        );
                      } else {
                        // Display existing banks
                        BankAccount bank = displayedBanks[index - 1]; // Adjust index for bank list
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BankDetail(bank: bank),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.all(8.0),
                            color: Colors.white, // Match color with existing banks
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(bank.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                Text('Balance: \$${bank.balance}', style: const TextStyle(fontSize: 16)),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _payFromWallet,
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      color: Colors.white, // Match color with existing wallets
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Pay from Wallet',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _payFromBank,
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      color: Colors.white, // Match color with existing banks
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Pay from Bank',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
