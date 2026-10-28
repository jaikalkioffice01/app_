import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/app_user.dart';

class AuthProvider extends ChangeNotifier {
  static const _kLoggedInKey = 'auth.isLoggedIn';
  static const _kUserKey = 'auth.user';

  AppUser? _user;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;

  AppUser? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Restore saved login. Call ONCE in main() before runApp.
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_kLoggedInKey) ?? false;

    if (loggedIn) {
      final raw = prefs.getString(_kUserKey);
      if (raw != null) {
        try {
          _user = AppUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        } catch (_) {
          _user = null;
        }
      }
      _isLoggedIn = true;
      notifyListeners();
    }
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
      await Future.delayed(const Duration(milliseconds: 500));

      _user = AppUser(
        id: 'u1',
        name: 'John Smith',
        email: email,
      );
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
      await Future.delayed(const Duration(milliseconds: 500));

      _user = AppUser(
        id: 'u2',
        name: name,
        email: email,
      );
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
    _isLoggedIn = false;
    _error = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLoggedInKey);
    await prefs.remove(_kUserKey);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedInKey, _isLoggedIn);
    if (_user != null) {
      await prefs.setString(_kUserKey, jsonEncode(_user!.toJson()));
    }
  }
}