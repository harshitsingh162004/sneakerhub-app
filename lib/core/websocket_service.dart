import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  StompClient? _client;
  final _storage = const FlutterSecureStorage();

  Future<void> connect({
    required int auctionId,
    required Function(dynamic) onBidReceived,
    required Function() onConnected,
  }) async {
    final token = await _storage.read(key: 'jwt_token');

    _client = StompClient(
      config: StompConfig.sockJS(
        url: AppConstants.wsUrl,
        onConnect: (frame) {
          onConnected();
          _client!.subscribe(
            destination: '/topic/auction/$auctionId',
            callback: (frame) {
              if (frame.body != null) {
                onBidReceived(frame.body!);
              }
            },
          );
        },
        beforeConnect: () async {
          await Future.delayed(const Duration(milliseconds: 200));
        },
        stompConnectHeaders: {
          'Authorization': 'Bearer $token',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $token',
        },
        onStompError: (frame) {
          print('STOMP error: ${frame.body}');
        },
        onDisconnect: (frame) {
          print('WebSocket disconnected');
        },
        onWebSocketError: (error) {
          print('WebSocket error: $error');
        },
      ),
    );
    _client!.activate();
  }

  void placeBid(int auctionId, double amount) {
    if (_client != null && _client!.connected) {
      _client!.send(
        destination: '/app/bid',
        body: '{"auctionId": $auctionId, "bidAmount": $amount}',
      );
    }
  }

  void disconnect() {
    _client?.deactivate();
    _client = null;
  }
}
