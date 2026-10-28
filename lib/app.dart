import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/auth_provider.dart';
import 'ui/auth/login_screen.dart';
import 'ui/shell/main_shell.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShopKart',
      home: auth.isLoggedIn ? const MainShell() : const LoginScreen(),
    );
  }
}