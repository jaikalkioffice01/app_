import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/category.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const String baseUrl = 'https://api.vastraliya.com';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Uri _uri(String path) {
    if (path.startsWith('http')) return Uri.parse(path);
    return Uri.parse(path.startsWith('/') ? '$baseUrl$path' : '$baseUrl/$path');
  }

  Map<String, String> _headers({String? token}) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  Future<Map<String, dynamic>> _postJson(
    List<String> candidates,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    Object? lastError;

    for (final path in candidates) {
      try {
        final response = await _client.post(
          _uri(path),
          headers: _headers(token: token),
          body: jsonEncode(body),
        );

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic>) return decoded;
          if (decoded is Map) return Map<String, dynamic>.from(decoded);
          throw const ApiException('Invalid API response');
        }

        if (response.statusCode == 404) {
          lastError = const ApiException('Endpoint not found');
          continue;
        }

        final decoded = jsonDecode(response.body);
        final message = decoded is Map ? (decoded['message'] ?? decoded['error'] ?? 'Request failed') : 'Request failed';
        lastError = ApiException(message.toString());
      } on SocketException {
        lastError = const ApiException('Network error. Please check connectivity.');
      } catch (error) {
        lastError = error is ApiException ? error : ApiException(error.toString());
      }
    }

    throw lastError ?? const ApiException('Unable to complete request');
  }

  Future<List<dynamic>> _getList(List<String> candidates, {String? token}) async {
    Object? lastError;

    for (final path in candidates) {
      try {
        final response = await _client.get(
          _uri(path),
          headers: _headers(token: token),
        );

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final decoded = jsonDecode(response.body);
          if (decoded is List) return decoded;
          if (decoded is Map) {
            for (final key in ['data', 'items', 'products', 'categories', 'result']) {
              final value = decoded[key];
              if (value is List) return value;
            }
          }
          throw const ApiException('Invalid list response');
        }

        if (response.statusCode == 404) {
          lastError = const ApiException('Endpoint not found');
          continue;
        }

        final decoded = jsonDecode(response.body);
        final message = decoded is Map ? (decoded['message'] ?? decoded['error'] ?? 'Request failed') : 'Request failed';
        lastError = ApiException(message.toString());
      } on SocketException {
        lastError = const ApiException('Network error. Please check connectivity.');
      } catch (error) {
        lastError = error is ApiException ? error : ApiException(error.toString());
      }
    }

    throw lastError ?? const ApiException('Unable to load data');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _postJson(
      const [
        'api/auth/login',
        'api/login',
        'auth/login',
        'login',
      ],
      {'email': email, 'password': password},
    );

    final data = response['data'] ?? response['user'] ?? response;
    if (data is! Map) {
      throw const ApiException('Login response was empty');
    }

    final userMap = Map<String, dynamic>.from(data is Map ? data : {});
    final token = response['token'] ?? response['access_token'] ?? response['jwt'] ?? userMap['token'];

    if (token == null) {
      return {'user': userMap, 'token': null};
    }

    return {'user': userMap, 'token': token.toString()};
  }

  Future<Map<String, dynamic>> signup(String name, String email, String password) async {
    final response = await _postJson(
      const [
        'api/auth/signup',
        'api/signup',
        'auth/signup',
        'register',
      ],
      {'name': name, 'email': email, 'password': password},
    );

    final data = response['data'] ?? response['user'] ?? response;
    if (data is! Map) {
      throw const ApiException('Signup response was empty');
    }

    final userMap = Map<String, dynamic>.from(data is Map ? data : {});
    final token = response['token'] ?? response['access_token'] ?? response['jwt'] ?? userMap['token'];

    if (token == null) {
      return {'user': userMap, 'token': null};
    }

    return {'user': userMap, 'token': token.toString()};
  }

  Future<List<Product>> getProducts({String? token}) async {
    final list = await _getList(
      const [
        'api/products',
        'api/product',
        'products',
      ],
      token: token,
    );

    return list.map((item) {
      if (item is Map) return Product.fromJson(Map<String, dynamic>.from(item));
      return Product(
        id: item.toString(),
        name: item.toString(),
        price: 0,
        description: 'No description available',
        category: 'General',
        imageUrl: '',
        rating: 0,
      );
    }).toList();
  }

  Future<List<Category>> getCategories({String? token}) async {
    final list = await _getList(
      const [
        'api/categories',
        'api/category',
        'categories',
      ],
      token: token,
    );

    return list.map((item) {
      if (item is Map) return Category.fromJson(Map<String, dynamic>.from(item));
      return Category(id: item.toString(), name: item.toString(), emoji: '📦');
    }).toList();
  }
}
