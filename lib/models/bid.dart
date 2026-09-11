class BidMessage {
  final int auctionId;
  final double bidAmount;
  final String bidderName;
  final double newCurrentPrice;
  final int totalBids;

  BidMessage({
    required this.auctionId,
    required this.bidAmount,
    required this.bidderName,
    required this.newCurrentPrice,
    required this.totalBids,
  });

  factory BidMessage.fromJson(Map<String, dynamic> json) => BidMessage(
        auctionId: json['auctionId'],
        bidAmount: (json['bidAmount'] as num).toDouble(),
        bidderName: json['bidderName'],
        newCurrentPrice: (json['newCurrentPrice'] as num).toDouble(),
        totalBids: json['totalBids'],
      );
}
