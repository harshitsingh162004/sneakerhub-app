import 'package:flutter/material.dart';
import '../../core/constants.dart';

class MyBidsScreen extends StatelessWidget {
  const MyBidsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bgDark,
      appBar: AppBar(
        backgroundColor: AppConstants.navyBlue,
        title: const Text('My Bids'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gavel_rounded, size: 60, color: AppConstants.textGrey),
            SizedBox(height: 16),
            Text('No bids placed yet', style: AppConstants.heading3),
            SizedBox(height: 8),
            Text('Start bidding on auctions!', style: AppConstants.bodyText),
          ],
        ),
      ),
    );
  }
}
