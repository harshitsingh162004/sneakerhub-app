import 'package:flutter/material.dart';
import '../../core/constants.dart';

class BidBottomSheet extends StatelessWidget {
  const BidBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConstants.navyBlue,
      child: const Center(
        child: Text('Bid Sheet', style: AppConstants.bodyText),
      ),
    );
  }
}
