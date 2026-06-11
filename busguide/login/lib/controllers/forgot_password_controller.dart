import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordController {
  final VoidCallback onStateChanged;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool isLoading = false;

  ForgotPasswordController({required this.onStateChanged});

  void dispose() {
    emailController.dispose();
  }

  Future<void> resetPassword(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    isLoading = true;
    onStateChanged();

    try {
      final supabase = Supabase.instance.client;

      // Mengirim email reset password dari Supabase
    await supabase.auth.resetPasswordForEmail(
      emailController.text.trim(),
      redirectTo: 'busguide://reset-password',
    );
      if (!context.mounted) return;
      _showSnackBar(context, "Tautan atur ulang kata sandi telah dikirim ke email", Colors.green);

      await Future.delayed(const Duration(milliseconds: 1000));
      if (!context.mounted) return;
      Navigator.pop(context);
    } on AuthException catch (e) {
      _showSnackBar(context, e.message, Colors.red);
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
