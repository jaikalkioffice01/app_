import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  final Set<String> _wishlistIds = <String>{};

  Set<String> get wishlistIds => _wishlistIds;

  // ── ADDED ────────────────────────────────────────────
  int get count => _wishlistIds.length;

  bool isSaved(String productId) => _wishlistIds.contains(productId);

  void toggle(String productId) {
    if (_wishlistIds.contains(productId)) {
      _wishlistIds.remove(productId);
    } else {
      _wishlistIds.add(productId);
    }
    notifyListeners();
  }
}