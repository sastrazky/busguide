import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterController {
  final VoidCallback onStateChanged;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool agree = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  RegisterController({required this.onStateChanged});

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    onStateChanged();
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
    onStateChanged();
  }

  void setAgreement(bool value) {
    agree = value;
    onStateChanged();
  }

  Future<void> register(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!agree) {
      _showSnackBar(context, "Harus menyetujui syarat & ketentuan", Colors.red);
      return;
    }

    isLoading = true;
    onStateChanged();

    try {
      final supabase = Supabase.instance.client;

      // ================= REGISTER DENGAN METADATA =================
      final response = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        data: {
          'full_name': nameController.text.trim(),
        },
      );

      final user = response.user;
      if (user == null) {
        throw Exception("Gagal membuat akun");
      }

      if (!context.mounted) return;
      _showSnackBar(context, "Daftar berhasil", Colors.green);

      await Future.delayed(const Duration(milliseconds: 800));

      if (!context.mounted) return;
      Navigator.pop(context);
    } on AuthException catch (e) {
      String errorMessage = "Daftar gagal";
      if (e.code == 'user_already_exists') {
        errorMessage = "Email sudah digunakan";
      } else if (e.code == 'weak_password') {
        errorMessage = "Password terlalu lemah";
      } else if (e.code == 'validation_failed') {
        errorMessage = "Format email tidak valid";
      } else {
        errorMessage = e.message;
      }
      _showSnackBar(context, errorMessage, Colors.red);
    } catch (e) {
      _showSnackBar(context, "Error: $e", Colors.red);
    } finally {
      isLoading = false;
      onStateChanged();
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
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
