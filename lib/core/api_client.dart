import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final _storage = const FlutterSecureStorage();
  late Dio _dio;
  bool _initialized = false;
  String? _cachedName;
  String? _cachedRole;
  String? _cachedEmail;

  void init() {
    if (_initialized) return;
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ));
    _initialized = true;
  }

  Dio get dio => _dio;

  Future<void> saveToken(String token) async =>
      await _storage.write(key: 'jwt_token', value: token);

  Future<void> saveName(String name) async {
    _cachedName = name;
    await _storage.write(key: 'user_name', value: name);
  }

  Future<void> saveRole(String role) async {
    _cachedRole = role;
    await _storage.write(key: 'user_role', value: role);
  }

  Future<void> saveEmail(String email) async {
    _cachedEmail = email;
    await _storage.write(key: 'user_email', value: email);
  }

  Future<String?> getToken() async => await _storage.read(key: 'jwt_token');

  Future<String?> getName() async {
    _cachedName ??= await _storage.read(key: 'user_name');
    return _cachedName;
  }

  Future<String?> getRole() async {
    _cachedRole ??= await _storage.read(key: 'user_role');
    return _cachedRole;
  }

  Future<String?> getEmail() async {
    _cachedEmail ??= await _storage.read(key: 'user_email');
    return _cachedEmail;
  }

  String? getCachedName() => _cachedName;
  String? getCachedRole() => _cachedRole;
  String? getCachedEmail() => _cachedEmail;

  Future<void> clearAll() async {
    _cachedName = null;
    _cachedRole = null;
    _cachedEmail = null;
    await _storage.deleteAll();
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null && token.isNotEmpty;
  }
}
