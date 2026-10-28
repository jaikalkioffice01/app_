import '../models/category.dart';
import '../models/product.dart';

class ProductRepository {
  List<Product> getProducts() {
    return [
      Product(
        id: 'p1',
        name: 'Nike Sneaker',
        price: 120,
        description: 'Lightweight sneakers for daily comfort and active movement.',
        category: 'Fashion',
        imageUrl: '',
        rating: 4.8,
      ),
      Product(
        id: 'p2',
        name: 'Smart Watch',
        price: 180,
        description: 'Track your health, calls, messages, and workouts in one device.',
        category: 'Electronics',
        imageUrl: '',
        rating: 4.7,
      ),
      Product(
        id: 'p3',
        name: 'Wireless Headphones',
        price: 90,
        description: 'Noise cancelling sound with long battery performance.',
        category: 'Electronics',
        imageUrl: '',
        rating: 4.9,
      ),
      Product(
        id: 'p4',
        name: 'Office Chair',
        price: 140,
        description: 'Comfortable ergonomic chair for long working sessions.',
        category: 'Home',
        imageUrl: '',
        rating: 4.6,
      ),
      Product(
        id: 'p5',
        name: 'Perfume',
        price: 60,
        description: 'Fresh fragrance with premium long-lasting notes.',
        category: 'Beauty',
        imageUrl: '',
        rating: 4.5,
      ),
      Product(
        id: 'p6',
        name: 'Running Shoes',
        price: 110,
        description: 'High performance footwear designed for running and training.',
        category: 'Fashion',
        imageUrl: '',
        rating: 4.8,
      ),
    ];
  }

  List<Category> getCategories() {
    return [
      Category(id: 'fashion', name: 'Fashion', emoji: '👟'),
      Category(id: 'electronics', name: 'Electronics', emoji: '📱'),
      Category(id: 'home', name: 'Home', emoji: '🏠'),
      Category(id: 'beauty', name: 'Beauty', emoji: '💄'),
    ];
  }
}
