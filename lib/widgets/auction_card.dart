import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../models/auction.dart';

class AuctionCard extends StatelessWidget {
  final Auction auction;
  final VoidCallback onTap;

  const AuctionCard({
    super.key,
    required this.auction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: AppConstants.cardGradient,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          border: Border.all(
            color: AppConstants.electricBlue.withOpacity(0.15),
          ),
          boxShadow: AppConstants.cardShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Sneaker image placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppConstants.navyBlue,
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  border: Border.all(
                      color: AppConstants.electricBlue.withOpacity(0.2)),
                ),
                child: const Icon(
                  Icons.sports_basketball_rounded,
                  color: AppConstants.electricBlue,
                  size: 40,
                ),
              ),

              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Live badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppConstants.success.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '● LIVE',
                        style: TextStyle(
                          color: AppConstants.success,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      auction.sneakerTitle,
                      style: const TextStyle(
                        color: AppConstants.textWhite,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${auction.brand} • Size ${auction.size}',
                      style: const TextStyle(
                        color: AppConstants.textGrey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Current Bid',
                              style: TextStyle(
                                color: AppConstants.textGrey,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              '₹${auction.currentPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: AppConstants.neonBlue,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Bids',
                              style: TextStyle(
                                color: AppConstants.textGrey,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              '${auction.totalBids}',
                              style: const TextStyle(
                                color: AppConstants.textWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Arrow
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppConstants.electricBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppConstants.electricBlue,
                  size: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
