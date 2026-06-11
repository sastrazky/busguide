import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../views/login_view.dart';

class ProfileController {
  final VoidCallback onStateChanged;

  User? user;
  String? localImage;
  String name = '';

  ProfileController({required this.onStateChanged});

  // ================= LOAD USER =================
  Future<void> loadUser() async {
    final currentUser = Supabase.instance.client.auth.currentUser;
    final prefs = await SharedPreferences.getInstance();
    final uid = currentUser?.id;

    user = currentUser;
    localImage = prefs.getString('profile_image_$uid');

    // Ambil nama dari tabel users (prioritas), fallback ke SharedPreferences
    if (currentUser != null) {
      try {
        final userData = await Supabase.instance.client
            .from('users')
            .select('name')
            .eq('id', currentUser.id)
            .single();
        name = userData['name'] ?? prefs.getString('name') ?? '';
      } catch (_) {
        name = prefs.getString('name') ?? '';
      }
    }

    onStateChanged();
  }

  // ================= LOGOUT =================
  Future<void> signOut(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    
    final prefs = await SharedPreferences.getInstance();
    final choice = prefs.getString('location_permission_choice');
    if (choice != 'always') {
      await prefs.remove('location_permission_choice');
    }
    await prefs.setBool('isLogin', false);
    
    if (!context.mounted) return;
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginView(),
      ),
      (route) => false,
    );
  }
}
