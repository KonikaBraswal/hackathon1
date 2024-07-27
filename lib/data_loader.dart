import 'dart:convert';
import 'dart:io';
import 'models.dart';

// Define a static path for the JSON file
const String staticFilePath = 'lib/db.json'; // Update this to the appropriate path

// Function to load wallets from the static JSON file
Future<List<Wallet>> loadWallets() async {
  try {
    // Load the JSON file from the static path
    final String contents = await File(staticFilePath).readAsString();
    final data = json.decode(contents);

    // Extract wallets list from the JSON data
    List<dynamic> walletsJson = data['wallets'];
    return walletsJson.map((json) => Wallet.fromJson(json)).toList();
  } catch (e) {
    print('Error loading wallets: $e');
    return [];
  }
}

// Function to save a wallet to the static JSON file
Future<void> saveWallet(Wallet wallet) async {
  try {
    final file = File(staticFilePath);

    // Check if the file exists
    if (!await file.exists()) {
      // If the file does not exist, create it with an empty wallets list
      await file.writeAsString(jsonEncode({'wallets': []}));
    }

    // Load existing wallets
    final String contents = await file.readAsString();
    final data = json.decode(contents);
    List<dynamic> walletsJson = data['wallets'];

    // Add new wallet to the list
    walletsJson.add(wallet.toJson());

    // Write updated wallets list back to the file
    await file.writeAsString(jsonEncode({'wallets': walletsJson}));
  } catch (e) {
    print('Error saving wallet: $e');
  }
}

// Function to delete a wallet from the static JSON file
Future<void> deleteWallet(Wallet wallet) async {
  try {
    final file = File(staticFilePath);

    // Load existing wallets
    final String contents = await file.readAsString();
    final data = json.decode(contents);
    List<dynamic> walletsJson = data['wallets'];

    // Remove wallet if amount is zero
    if (wallet.amount == 0) {
      walletsJson.removeWhere((w) => Wallet.fromJson(w).account == wallet.account);

      // Write updated wallets list back to the file
      await file.writeAsString(jsonEncode({'wallets': walletsJson}));
    } else {
      print('Cannot delete wallet: Amount is not zero.');
    }
  } catch (e) {
    print('Error deleting wallet: $e');
  }
}
