import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../providers/auction_provider.dart';

class CreateAuctionScreen extends StatefulWidget {
  const CreateAuctionScreen({super.key});

  @override
  State<CreateAuctionScreen> createState() => _CreateAuctionScreenState();
}

class _CreateAuctionScreenState extends State<CreateAuctionScreen> {
  final _titleController = TextEditingController();
  final _brandController = TextEditingController();
  final _descController = TextEditingController();
  final _sizeController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _startPriceController = TextEditingController();
  final _buyNowController = TextEditingController();
  String _condition = 'NEW';
  int _duration = 24;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _brandController.dispose();
    _descController.dispose();
    _sizeController.dispose();
    _imageUrlController.dispose();
    _startPriceController.dispose();
    _buyNowController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (_titleController.text.isEmpty || _startPriceController.text.isEmpty)
      return;
    setState(() => _isLoading = true);
    final success = await context.read<AuctionProvider>().createAuction(
          title: _titleController.text,
          brand: _brandController.text,
          description: _descController.text,
          size: _sizeController.text,
          condition: _condition,
          imageUrl: _imageUrlController.text,
          startPrice: double.tryParse(_startPriceController.text) ?? 0,
          buyNowPrice: double.tryParse(_buyNowController.text) ?? 0,
          durationHours: _duration,
        );
    setState(() => _isLoading = false);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Auction created successfully! 🎉'),
          backgroundColor: AppConstants.success,
        ),
      );
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bgDark,
      appBar: AppBar(
        backgroundColor: AppConstants.navyBlue,
        title: const Text('Create Auction'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField(
                'Sneaker Title', _titleController, 'Nike Air Jordan 1 Retro'),
            _buildField('Brand', _brandController, 'Nike'),
            _buildField('Description', _descController, 'Brand new, never worn',
                maxLines: 3),
            _buildField('Size (UK)', _sizeController, 'UK 9'),
            _buildField('Image URL', _imageUrlController, 'https://...'),
            _buildField('Starting Price (₹)', _startPriceController, '5000',
                keyboardType: TextInputType.number),
            _buildField('Buy Now Price (₹)', _buyNowController, '15000',
                keyboardType: TextInputType.number),

            // Condition
            const SizedBox(height: 8),
            const Text('Condition',
                style: TextStyle(
                    color: AppConstants.textLight,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: ['NEW', 'USED', 'LIKE NEW'].map((c) {
                final selected = _condition == c;
                return GestureDetector(
                  onTap: () => setState(() => _condition = c),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppConstants.electricBlue
                          : AppConstants.cardBlue,
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    ),
                    child: Text(
                      c,
                      style: TextStyle(
                        color: selected ? Colors.white : AppConstants.textGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Duration
            const SizedBox(height: 20),
            const Text('Auction Duration',
                style: TextStyle(
                    color: AppConstants.textLight,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [24, 48, 72].map((h) {
                final selected = _duration == h;
                return GestureDetector(
                  onTap: () => setState(() => _duration = h),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppConstants.electricBlue
                          : AppConstants.cardBlue,
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    ),
                    child: Text(
                      '${h}h',
                      style: TextStyle(
                        color: selected ? Colors.white : AppConstants.textGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            GestureDetector(
              onTap: _isLoading ? null : _create,
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppConstants.blueGradient,
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  boxShadow: AppConstants.glowShadow,
                ),
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2)
                      : const Text(
                          'CREATE AUCTION',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppConstants.textLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: const TextStyle(color: AppConstants.textWhite),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppConstants.textGrey),
              filled: true,
              fillColor: AppConstants.cardBlue,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                borderSide: const BorderSide(
                    color: AppConstants.electricBlue, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
