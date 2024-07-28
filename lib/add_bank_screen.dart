import 'package:flutter/material.dart';
import 'aisp.dart'; // Import the aisp.dart file

class AddBankScreen extends StatelessWidget {
  const AddBankScreen({super.key});

  void _confirmConsent(BuildContext context) async {
    // Call the retrieveAccessToken function
    await retrieveAccessToken();

    // Show a SnackBar message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Consent Confirmed')),
    );

    // Navigate back to the previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bank'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please read the following consent agreement carefully.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'By confirming, you agree to the terms and conditions of this consent.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _confirmConsent(context),
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
