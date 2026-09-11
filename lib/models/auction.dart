class Auction {
  final int auctionId;
  final String sneakerTitle;
  final String brand;
  final String size;
  final String condition;
  final String imageUrl;
  final double startPrice;
  final double currentPrice;
  final double buyNowPrice;
  final String endTime;
  final String status;
  final String sellerName;
  final int totalBids;

  Auction({
    required this.auctionId,
    required this.sneakerTitle,
    required this.brand,
    required this.size,
    required this.condition,
    required this.imageUrl,
    required this.startPrice,
    required this.currentPrice,
    required this.buyNowPrice,
    required this.endTime,
    required this.status,
    required this.sellerName,
    required this.totalBids,
  });

  factory Auction.fromJson(Map<String, dynamic> json) => Auction(
        auctionId: json['auctionId'],
        sneakerTitle: json['sneakerTitle'],
        brand: json['brand'],
        size: json['size'] ?? 'N/A',
        condition: json['condition'] ?? 'N/A',
        imageUrl: json['imageUrl'] ?? '',
        startPrice: (json['startPrice'] as num).toDouble(),
        currentPrice: (json['currentPrice'] as num).toDouble(),
        buyNowPrice: (json['buyNowPrice'] as num).toDouble(),
        endTime: json['endTime'],
        status: json['status'],
        sellerName: json['sellerName'],
        totalBids: json['totalBids'] ?? 0,
      );
}
