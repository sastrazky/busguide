import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  bool isLogin = prefs.getBool('isLogin') ?? false;
  String name = prefs.getString('name') ?? "";

  runApp(
    MyApp(
      isLogin: isLogin,
      name: name,
    ),
  );
}

// ================= APP =================
class MyApp extends StatelessWidget {
  final bool isLogin;
  final String name;

  const MyApp({
    super.key,
    required this.isLogin,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF0056B3),
        scaffoldBackgroundColor: const Color(0xFFF5F7F9),
        cardColor: Colors.white,
      ),

      // ================= SPLASH =================
      home: SplashScreen(
        isLogin: isLogin,
        name: name,
      ),
    );
  }
}

// ================= SPLASH SCREEN =================
class SplashScreen extends StatefulWidget {
  final bool isLogin;
  final String name;

  const SplashScreen({
    super.key,
    required this.isLogin,
    required this.name,
  });

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

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
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.directions_bus,
              size: 80,
              color: Colors.white,
            ),

            SizedBox(height: 20),

            Text(
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