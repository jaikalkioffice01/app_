import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/repositories/product_repository.dart';
import 'state/auth_provider.dart';
import 'state/cart_provider.dart';
import 'state/products_provider.dart';
import 'state/wishlist_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restore saved login BEFORE the widget tree builds.
  final auth = AuthProvider();
  await auth.loadSession();

  runApp(
    MultiProvider(
      providers: [
        // Use .value so the SAME instance (with restored session) is shared.
        ChangeNotifierProvider.value(value: auth),
        ChangeNotifierProvider(
          create: (_) => ProductsProvider(ProductRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(),
        ),
      ],
      child: const ShopApp(),
    ),
  );
}