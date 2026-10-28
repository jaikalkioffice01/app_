import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/app_user.dart';
import '../data/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  static const _kLoggedInKey = 'auth.isLoggedIn';
  static const _kUserKey = 'auth.user';
  static const _kTokenKey = 'auth.token';

  final ApiService _apiService = ApiService();

  AppUser? _user;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;
  String? _token;

  AppUser? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_kLoggedInKey) ?? false;

    if (!loggedIn) return;

    final raw = prefs.getString(_kUserKey);
    final savedToken = prefs.getString(_kTokenKey);

    if (raw != null) {
      try {
        _user = AppUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        _token = savedToken;
        _isLoggedIn = true;
      } catch (_) {
        _user = null;
        _token = null;
        _isLoggedIn = false;
      }
    }

    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _error = 'Email and password are required';
      notifyListeners();
      throw Exception(_error);
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);
      final userJson = response['user'];
      final token = response['token'];

      if (userJson is Map) {
        _user = AppUser.fromJson(Map<String, dynamic>.from(userJson));
      } else {
        _user = AppUser(
          id: 'u1',
          name: 'John Smith',
          email: email,
          token: token?.toString(),
        );
      }

      if (token != null && token.toString().isNotEmpty) {
        _token = token.toString();
      }

      _isLoggedIn = true;
      await _persist();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signup(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _error = 'Name, email and password are required';
      notifyListeners();
      throw Exception(_error);
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.signup(name, email, password);
      final userJson = response['user'];
      final token = response['token'];

      if (userJson is Map) {
        _user = AppUser.fromJson(Map<String, dynamic>.from(userJson));
      } else {
        _user = AppUser(
          id: 'u2',
          name: name,
          email: email,
          token: token?.toString(),
        );
      }

      if (token != null && token.toString().isNotEmpty) {
        _token = token.toString();
      }

      _isLoggedIn = true;
      await _persist();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    _isLoggedIn = false;
    _error = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLoggedInKey);
    await prefs.remove(_kUserKey);
    await prefs.remove(_kTokenKey);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedInKey, _isLoggedIn);
    if (_user != null) {
      await prefs.setString(_kUserKey, jsonEncode(_user!.toJson()));
    }
    if (_token != null) {
      await prefs.setString(_kTokenKey, _token!);
    }
  }
}
