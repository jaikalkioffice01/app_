import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/products_provider.dart';
import '../../state/wishlist_provider.dart';
import '../product/product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductsProvider>().products;
    final wishlist = context.watch<WishlistProvider>().wishlistIds;

    final wishListProducts = products.where((p) => wishlist.contains(p.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: wishListProducts.isEmpty
          ? const Center(child: Text('No saved items'))
          : ListView.builder(
        itemCount: wishListProducts.length,
        itemBuilder: (context, index) {
          final product = wishListProducts[index];
          return ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: Text(product.name),
            subtitle: Text('\$${product.price.toInt()}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}