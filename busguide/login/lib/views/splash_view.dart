import 'dart:async';
import 'package:flutter/material.dart';
import 'login_view.dart';
import 'home_view.dart';

class SplashView extends StatefulWidget {
  final bool isLogin;
  final String name;

  const SplashView({
    super.key,
    required this.isLogin,
    required this.name,
  });

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  // ================= NAVIGATE =================
  void _navigateToNextPage() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => widget.isLogin
                ? HomeView(name: widget.name)
                : const LoginView(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0056B3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_bus,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'Bus Guide',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
