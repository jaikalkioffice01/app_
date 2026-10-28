import 'package:flutter/material.dart';

import '../data/models/product.dart';
import '../data/repositories/product_repository.dart';

class ProductsProvider extends ChangeNotifier {
  final ProductRepository _repository;

  ProductsProvider(this._repository) {
    _products = _repository.getProducts();
  }

  late final List<Product> _products;

  List<Product> get products => _products;

  List<Product> getPopularProducts() {
    return _products.take(3).toList();
  }
}