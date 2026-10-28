import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/cart_provider.dart';
import '../state/wishlist_provider.dart';
import '../ui/cart/cart_screen.dart';
import '../ui/category/category_screen.dart';
import '../ui/home/home_screen.dart';
import '../ui/profile/profile_screen.dart';
import '../ui/wishlist/wishlist_screen.dart';

/// Global key so pushed routes (like ProductDetailScreen) can switch tabs.
final mainShellKey = GlobalKey<MainShellState>();

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = const [
    HomeScreen(),
    CategoryScreen(),
    CartScreen(),
    WishlistScreen(),
    ProfileScreen(),
  ];

  void selectTab(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;
    final wishlistCount = context.watch<WishlistProvider>().count;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: selectTab,
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
            icon: _BadgeIcon(
              icon: Icons.shopping_cart_outlined,
              count: cartCount,
            ),
            selectedIcon: _BadgeIcon(
              icon: Icons.shopping_cart_rounded,
              count: cartCount,
            ),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: _BadgeIcon(
              icon: Icons.favorite_border,
              count: wishlistCount,
            ),
            selectedIcon: _BadgeIcon(
              icon: Icons.favorite,
              count: wishlistCount,
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
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final int count;

  const _BadgeIcon({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return Icon(icon);
    return Badge(
      label: Text(count > 99 ? '99+' : '$count'),
      child: Icon(icon),
    );
  }
}
