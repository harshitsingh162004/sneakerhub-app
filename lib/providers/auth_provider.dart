import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final _api = ApiClient();

  bool _isLoading = false;
  String? _error;
  String? _userName;
  String? _userRole;
  String? _userEmail;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userName => _userName;
  String? get userRole => _userRole;
  String? get userEmail => _userEmail;

  Future<void> loadUserData() async {
    _userName = await _api.getName();
    _userRole = await _api.getRole();
    _userEmail = await _api.getEmail();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.dio.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );
      final user = User.fromJson(response.data);
      await _api.saveToken(user.token);
      await _api.saveName(user.name);
      await _api.saveRole(user.role);
      await _api.saveEmail(email);
      _userName = user.name;
      _userRole = user.role;
      _userEmail = email;
      _isLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _error =
          e.response?.data?['message'] ?? 'Login failed. Check credentials.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
      String name, String email, String password, String role) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.dio.post(
        '/api/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        },
      );
      final user = User.fromJson(response.data);
      await _api.saveToken(user.token);
      await _api.saveName(user.name);
      await _api.saveRole(user.role);
      await _api.saveEmail(email);
      _userName = user.name;
      _userRole = user.role;
      _userEmail = email;
      _isLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? 'Registration failed.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _api.clearAll();
    _userName = null;
    _userRole = null;
    _userEmail = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
