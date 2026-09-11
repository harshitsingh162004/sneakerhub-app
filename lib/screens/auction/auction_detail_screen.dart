import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/websocket_service.dart';
import '../../models/auction.dart';
import '../../models/bid.dart';
import '../../providers/auction_provider.dart';
import '../../core/api_client.dart';

class AuctionDetailScreen extends StatefulWidget {
  final int auctionId;
  const AuctionDetailScreen({super.key, required this.auctionId});

  @override
  State<AuctionDetailScreen> createState() => _AuctionDetailScreenState();
}

class _AuctionDetailScreenState extends State<AuctionDetailScreen> {
  final _wsService = WebSocketService();
  Auction? _auction;
  final List<BidMessage> _liveBids = [];
  bool _isConnected = false;
  bool _isLoading = true;
  final _bidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAuction();
  }

  Future<void> _loadAuction() async {
    final auction =
        await context.read<AuctionProvider>().getAuctionById(widget.auctionId);
    if (mounted) {
      setState(() {
        _auction = auction;
        _isLoading = false;
      });
      _connectWebSocket();
    }
  }

  void _connectWebSocket() {
    _wsService.connect(
      auctionId: widget.auctionId,
      onConnected: () {
        if (mounted) setState(() => _isConnected = true);
      },
      onBidReceived: (data) {
        final bid = BidMessage.fromJson(json.decode(data));
        if (mounted) {
          setState(() {
            _liveBids.insert(0, bid);
            _auction = Auction(
              auctionId: _auction!.auctionId,
              sneakerTitle: _auction!.sneakerTitle,
              brand: _auction!.brand,
              size: _auction!.size,
              condition: _auction!.condition,
              imageUrl: _auction!.imageUrl,
              startPrice: _auction!.startPrice,
              currentPrice: bid.newCurrentPrice,
              buyNowPrice: _auction!.buyNowPrice,
              endTime: _auction!.endTime,
              status: _auction!.status,
              sellerName: _auction!.sellerName,
              totalBids: bid.totalBids,
            );
          });
          context.read<AuctionProvider>().updateAuctionPrice(
              widget.auctionId, bid.newCurrentPrice, bid.totalBids);
        }
      },
    );
  }

  void _showBidSheet() {
    if (_auction == null) return;

    // Prevent seller from bidding on own auction
    final currentUserName = ApiClient().getCachedName();
    if (currentUserName == _auction!.sellerName) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You cannot bid on your own auction'),
          backgroundColor: AppConstants.danger,
        ),
      );
      return;
    }
    _bidController.text = (_auction!.currentPrice + 100).toStringAsFixed(0);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.navyBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _buildBidSheet(),
    );
  }

  Widget _buildBidSheet() {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppConstants.textGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Place Your Bid', style: AppConstants.heading2),
          const SizedBox(height: 4),
          Text(
            'Current bid: ₹${_auction!.currentPrice.toStringAsFixed(0)}',
            style: const TextStyle(color: AppConstants.textGrey),
          ),
          const SizedBox(height: 24),
          // Bid amount field
          TextFormField(
            controller: _bidController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: AppConstants.textWhite,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: const TextStyle(
                color: AppConstants.electricBlue,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
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
          const SizedBox(height: 12),
          // Quick amounts
          Wrap(
            spacing: 8,
            children: [100, 500, 1000, 2000].map((increment) {
              return GestureDetector(
                onTap: () {
                  final current = double.tryParse(_bidController.text) ?? 0;
                  _bidController.text =
                      (current + increment).toStringAsFixed(0);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppConstants.cardBlue,
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    border: Border.all(
                        color: AppConstants.electricBlue.withOpacity(0.3)),
                  ),
                  child: Text(
                    '+₹$increment',
                    style: const TextStyle(
                      color: AppConstants.electricBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // Confirm button
          GestureDetector(
            onTap: () async {
              final amount = double.tryParse(_bidController.text) ?? 0;
              if (amount <= _auction!.currentPrice) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bid must be higher than current price'),
                    backgroundColor: AppConstants.danger,
                  ),
                );
                return;
              }
              // Place via WebSocket
              _wsService.placeBid(widget.auctionId, amount);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Bid placed! 🔥'),
                  backgroundColor: AppConstants.success,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppConstants.blueGradient,
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                boxShadow: AppConstants.glowShadow,
              ),
              child: const Center(
                child: Text(
                  'CONFIRM BID',
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _wsService.disconnect();
    _bidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppConstants.bgDark,
        body: Center(
          child: CircularProgressIndicator(color: AppConstants.electricBlue),
        ),
      );
    }

    if (_auction == null) {
      return Scaffold(
        backgroundColor: AppConstants.bgDark,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: const Center(
          child: Text('Auction not found', style: AppConstants.bodyText),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.bgDark,
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppConstants.navyBlue,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0D1F3C), Color(0xFF050B18)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppConstants.cardBlue,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusL),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.electricBlue.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.sports_basketball_rounded,
                        size: 80,
                        color: AppConstants.electricBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.cardBlue.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 18),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.cardBlue.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.favorite_border,
                      color: Colors.white, size: 20),
                  onPressed: () {},
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status + brand row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppConstants.success.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppConstants.success.withOpacity(0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppConstants.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'LIVE',
                              style: TextStyle(
                                color: AppConstants.success,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // WS connection indicator
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _isConnected
                                  ? AppConstants.success
                                  : AppConstants.textGrey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isConnected ? 'Connected' : 'Connecting...',
                            style: TextStyle(
                              color: _isConnected
                                  ? AppConstants.success
                                  : AppConstants.textGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Title
                  Text(_auction!.sneakerTitle, style: AppConstants.heading1),
                  const SizedBox(height: 4),
                  Text(
                    '${_auction!.brand} • Size ${_auction!.size} • ${_auction!.condition}',
                    style: const TextStyle(
                        color: AppConstants.textGrey, fontSize: 14),
                  ),

                  const SizedBox(height: 24),

                  // Bid stats
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppConstants.cardGradient,
                      borderRadius: BorderRadius.circular(AppConstants.radiusL),
                      border: Border.all(
                          color: AppConstants.electricBlue.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _statItem(
                            'Current Bid',
                            '₹${_auction!.currentPrice.toStringAsFixed(0)}',
                            AppConstants.neonBlue,
                          ),
                        ),
                        Container(
                            width: 1,
                            height: 40,
                            color: AppConstants.electricBlue.withOpacity(0.2)),
                        Expanded(
                          child: _statItem(
                            'Total Bids',
                            '${_auction!.totalBids}',
                            AppConstants.textWhite,
                          ),
                        ),
                        Container(
                            width: 1,
                            height: 40,
                            color: AppConstants.electricBlue.withOpacity(0.2)),
                        Expanded(
                          child: _statItem(
                            'Seller',
                            _auction!.sellerName,
                            AppConstants.textWhite,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Live bid feed
                  if (_liveBids.isNotEmpty) ...[
                    const Text('Live Bid Feed', style: AppConstants.heading3),
                    const SizedBox(height: 12),
                    ..._liveBids.take(5).map((bid) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppConstants.cardBlue,
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusS),
                            border: Border.all(
                                color:
                                    AppConstants.electricBlue.withOpacity(0.1)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppConstants.electricBlue
                                          .withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.person,
                                        color: AppConstants.electricBlue,
                                        size: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    bid.bidderName.split('@').first,
                                    style: const TextStyle(
                                      color: AppConstants.textWhite,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '₹${bid.bidAmount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: AppConstants.neonBlue,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bid button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: AppConstants.navyBlue,
          border: Border(
            top: BorderSide(color: AppConstants.electricBlue.withOpacity(0.2)),
          ),
        ),
        child: GestureDetector(
          onTap: _showBidSheet,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: AppConstants.blueGradient,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              boxShadow: AppConstants.glowShadow,
            ),
            child: const Center(
              child: Text(
                'PLACE BID 🔥',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(color: AppConstants.textGrey, fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
