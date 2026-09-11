import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../core/constants.dart';
import '../models/auction.dart';

class AuctionProvider extends ChangeNotifier {
  final _api = ApiClient();

  List<Auction> _auctions = [];
  bool _isLoading = false;
  String? _error;
  String? _currentUserEmail;

  List<Auction> get auctions => _auctions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCurrentUser() async {
    _currentUserEmail = await _api.getEmail();
  }

  bool isAuctionOwner(String sellerName) {
    final userName = _api.getCachedName();
    return userName != null && userName == sellerName;
  }

  Future<void> fetchAuctions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.dio.get('/api/auctions');
      _auctions = (response.data as List)
          .map((json) => Auction.fromJson(json))
          .toList();
      _isLoading = false;
      notifyListeners();
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? 'Failed to load auctions.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Auction?> getAuctionById(int id) async {
    try {
      final response = await _api.dio.get('/api/auctions/$id');
      return Auction.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  // Update auction in local list when new bid comes in via WebSocket
  void updateAuctionPrice(int auctionId, double newPrice, int totalBids) {
    final index = _auctions.indexWhere((a) => a.auctionId == auctionId);
    if (index != -1) {
      final old = _auctions[index];
      _auctions[index] = Auction(
        auctionId: old.auctionId,
        sneakerTitle: old.sneakerTitle,
        brand: old.brand,
        size: old.size,
        condition: old.condition,
        imageUrl: old.imageUrl,
        startPrice: old.startPrice,
        currentPrice: newPrice,
        buyNowPrice: old.buyNowPrice,
        endTime: old.endTime,
        status: old.status,
        sellerName: old.sellerName,
        totalBids: totalBids,
      );
      notifyListeners();
    }
  }

  Future<bool> createAuction({
    required String title,
    required String brand,
    required String description,
    required String size,
    required String condition,
    required String imageUrl,
    required double startPrice,
    required double buyNowPrice,
    required int durationHours,
  }) async {
    try {
      await _api.dio.post('/api/auctions/create', data: {
        'title': title,
        'brand': brand,
        'description': description,
        'size': size,
        'condition': condition,
        'imageUrl': imageUrl,
        'startPrice': startPrice,
        'buyNowPrice': buyNowPrice,
        'durationHours': durationHours,
      });
      await fetchAuctions();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> placeBid(int auctionId, double amount) async {
    try {
      await _api.dio.post('/api/auctions/bid', data: {
        'auctionId': auctionId,
        'bidAmount': amount,
      });
      await fetchAuctions(); // refresh home screen
      return true;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? 'Bid failed.';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
