class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawCategory = json['category'] ?? json['categoryName'] ?? json['type'] ?? 'General';
    final rawPrice = json['price'] ?? json['amount'] ?? json['salePrice'] ?? 0.0;
    final rawRating = json['rating'] ?? json['averageRating'] ?? 0.0;
    final rawImage = json['image'] ?? json['imageUrl'] ?? json['thumbnail'] ?? '';

    return Product(
      id: (json['id'] ?? json['productId'] ?? json['_id'] ?? json['slug'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? 'Product').toString(),
      price: double.tryParse(rawPrice.toString()) ?? 0.0,
      description: (json['description'] ?? json['shortDescription'] ?? 'No description available.').toString(),
      category: rawCategory.toString(),
      imageUrl: rawImage.toString(),
      rating: double.tryParse(rawRating.toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'description': description,
    'category': category,
    'imageUrl': imageUrl,
    'rating': rating,
  };
}
