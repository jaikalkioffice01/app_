import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/product.dart';
import '../../state/cart_provider.dart';
import '../../state/wishlist_provider.dart';
import '../shell/main_shell.dart';   // ← for mainShellKey

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  void _addToCart() {
    final cart = context.read<CartProvider>();
    for (var i = 0; i < _quantity; i++) {
      cart.addItem(widget.product);
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Added $_quantity × ${widget.product.name} to cart'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  /// Pops the detail screen and switches MainShell to [tabIndex].
  void _goToTab(int tabIndex) {
    Navigator.popUntil(context, (route) => route.isFirst);
    mainShellKey.currentState?.selectTab(tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wishlist = context.watch<WishlistProvider>();
    final cartCount = context.watch<CartProvider>().itemCount;
    final product = widget.product;
    final isSaved = wishlist.isSaved(product.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App bar ─────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              // Cart icon with badge
              IconButton(
                tooltip: 'Cart',
                onPressed: () => _goToTab(2),
                icon: Badge(
                  isLabelVisible: cartCount > 0,
                  label: Text(cartCount > 99 ? '99+' : '$cartCount'),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
              ),

              // Wishlist icon with badge
              IconButton(
                tooltip: isSaved ? 'Remove from wishlist' : 'Add to wishlist',
                onPressed: () =>
                    context.read<WishlistProvider>().toggle(product.id),
                icon: Badge(
                  isLabelVisible: wishlist.count > 0,
                  label: Text(
                    wishlist.count > 99 ? '99+' : '${wishlist.count}',
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey(isSaved),
                      color: isSaved ? Colors.red : null,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _HeroImage(productName: product.name),
            ),
          ),

          // ── Body ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured product',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        final full = i < product.rating.floor();
                        return Icon(
                          full ? Icons.star : Icons.star_border,
                          size: 18,
                          color: Colors.amber.shade600,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        '${product.rating}  ·  4.8k reviews',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: theme.dividerColor, height: 1),
                  const SizedBox(height: 24),
                  Text(
                    'Description',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: theme.dividerColor, height: 1),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        'Quantity',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      _QuantitySelector(
                        value: _quantity,
                        onIncrement: _increment,
                        onDecrement: _decrement,
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── CTA bar ─────────────────────────────────────────────────
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _addToCart,
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: Text(
                    'Add to cart  ·  \$${(product.price * _quantity).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Bottom nav bar (visual, tab-switch on tap) ──────────
          NavigationBar(
            selectedIndex: 0,          // we're "in" the home tab stack
            onDestinationSelected: (index) => _goToTab(index),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Icons.grid_view_outlined),
                selectedIcon: Icon(Icons.grid_view_rounded),
                label: 'Categories',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: cartCount > 0,
                  label: Text(cartCount > 99 ? '99+' : '$cartCount'),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: cartCount > 0,
                  label: Text(cartCount > 99 ? '99+' : '$cartCount'),
                  child: const Icon(Icons.shopping_cart_rounded),
                ),
                label: 'Cart',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: wishlist.count > 0,
                  label: Text(
                    wishlist.count > 99 ? '99+' : '${wishlist.count}',
                  ),
                  child: const Icon(Icons.favorite_border),
                ),
                selectedIcon: Badge(
                  isLabelVisible: wishlist.count > 0,
                  label: Text(
                    wishlist.count > 99 ? '99+' : '${wishlist.count}',
                  ),
                  child: const Icon(Icons.favorite),
                ),
                label: 'Wishlist',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero image placeholder
// ---------------------------------------------------------------------------

class _HeroImage extends StatelessWidget {
  final String productName;

  const _HeroImage({required this.productName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.tertiaryContainer,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          size: 120,
          color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quantity selector
// ---------------------------------------------------------------------------

class _QuantitySelector extends StatelessWidget {
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantitySelector({
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: value > 1 ? onDecrement : null,
            icon: const Icon(Icons.remove, size: 20),
            tooltip: 'Decrease',
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add, size: 20),
            tooltip: 'Increase',
          ),
        ],
      ),
    );
  }
}