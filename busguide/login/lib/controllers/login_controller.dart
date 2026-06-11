import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../views/home_view.dart';

class LoginController {
  static bool isPasswordLoginInProgress = false;

  final VoidCallback onStateChanged;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  LoginController({required this.onStateChanged});

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    onStateChanged();
  }

  // ================= LOGIN =================
  Future<void> login(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    // ================= VALIDASI EMAIL =================
    if (!emailController.text.trim().contains("@gmail.com")) {
      _showSnackBar(context, "Format Email Salah", Colors.red);
      return;
    }

    isLoading = true;
    onStateChanged();
    isPasswordLoginInProgress = true;

    try {
      // ================= LOGIN SUPABASE =================
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Login gagal');
      }

      final userData = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      String name = userData['name'] ?? '';

      // ================= SIMPAN LOGIN =================
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogin', true);
      await prefs.setString('name', name);

      // ================= SUCCESS =================
      if (!context.mounted) return;
      _showSnackBar(context, "Login berhasil", Colors.green);

      // ================= DELAY =================
      await Future.delayed(const Duration(milliseconds: 800));

      // ================= PINDAH HOME =================
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeView(name: name)),
      );
    } on AuthException catch (e) {
      String errorMessage = "Login gagal";
      if (e.code == 'invalid_credentials') {
        errorMessage = "Email atau password salah";
      } else if (e.code == 'validation_failed') {
        errorMessage = "Format email tidak valid";
      } else if (e.message.contains("Email not confirmed")) {
        errorMessage = "Email belum dikonfirmasi";
      } else {
        errorMessage = e.message;
      }
      _showSnackBar(context, errorMessage, Colors.red);
    } catch (e) {
      _showSnackBar(context, "Terjadi kesalahan: $e", Colors.red);
    } finally {
      isLoading = false;
      isPasswordLoginInProgress = false;
      onStateChanged();
    }
  }

  // ================= GOOGLE LOGIN =================
  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'busguide://login-callback',
      );
    } catch (e) {
      _showSnackBar(context, e.toString(), Colors.red);
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
