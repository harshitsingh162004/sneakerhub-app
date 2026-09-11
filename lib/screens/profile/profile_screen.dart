import 'package:flutter/material.dart';
import '../../core/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bgDark,
      appBar: AppBar(
        backgroundColor: AppConstants.navyBlue,
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('Profile Screen', style: AppConstants.bodyText),
      ),
    );
  }
}
