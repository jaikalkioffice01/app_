import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductsProvider extends ChangeNotifier {
  final ProductRepository _repository;

  ProductsProvider(this._repository) {
    loadProducts();
    loadCategories();
  }

  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  bool _categoriesLoading = false;

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get categoriesLoading => _categoriesLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _repository.getProducts();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    _categoriesLoading = true;
    notifyListeners();

    try {
      _categories = await _repository.getCategories();
    } finally {
      _categoriesLoading = false;
      notifyListeners();
    }
  }

  List<Product> getPopularProducts() {
    return _products.take(3).toList();
  }
}
