import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileController {
  final VoidCallback onStateChanged;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  bool isLoading = true;

  EditProfileController({required this.onStateChanged});

  void dispose() {
    nameController.dispose();
    emailController.dispose();
  }

  // ================= LOAD DATA PENGGUNA =================
  Future<void> loadUserData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        emailController.text = user.email ?? '';
        
        // Ambil nama terbaru dari database Supabase
        final userData = await Supabase.instance.client
            .from('users')
            .select()
            .eq('id', user.id)
            .single();
            
        nameController.text = userData['name'] ?? '';
      }
    } catch (e) {
      // Fallback ke SharedPreferences jika database gagal diakses
      final prefs = await SharedPreferences.getInstance();
      nameController.text = prefs.getString('name') ?? '';
    } finally {
      isLoading = false;
      onStateChanged();
    }
  }

  // ================= SIMPAN PROFIL =================
  Future<void> saveProfile(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    isLoading = true;
    onStateChanged();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception("User tidak ditemukan");
      }

      final newName = nameController.text.trim();

      // ================= UPDATE DI SUPABASE =================
      await Supabase.instance.client
          .from('users')
          .update({'name': newName})
          .eq('id', user.id);

      // ================= UPDATE DI LOCAL STORAGE =================
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', newName);

      if (!context.mounted) return;
      _showSnackBar(context, "Profil berhasil diperbarui", Colors.green);

      // Delay sebentar lalu kembali ke halaman profil
      await Future.delayed(const Duration(milliseconds: 800));
      if (!context.mounted) return;
      Navigator.pop(context);
    } catch (e) {
      _showSnackBar(context, "Gagal memperbarui profil: $e", Colors.red);
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
