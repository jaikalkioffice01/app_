class AppUser {
  final String id;
  final String name;
  final String email;
  final String? token;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.token,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    if (token != null) 'token': token,
  };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: (json['id'] ?? json['userId'] ?? json['_id'] ?? 'u1').toString(),
    name: (json['name'] ?? json['full_name'] ?? json['username'] ?? 'User').toString(),
    email: (json['email'] ?? 'user@email.com').toString(),
    token: json['token'] ?? json['access_token'] ?? json['jwt'],
  );
}
