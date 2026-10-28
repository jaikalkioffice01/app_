class Category {
  final String id;
  final String name;
  final String emoji;

  Category({
    required this.id,
    required this.name,
    required this.emoji,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: (json['id'] ?? json['categoryId'] ?? json['_id'] ?? json['slug'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? 'Category').toString(),
      emoji: (json['emoji'] ?? json['icon'] ?? '📦').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'emoji': emoji,
  };
}
