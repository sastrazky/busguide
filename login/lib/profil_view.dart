import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class ProfileView extends StatelessWidget {
  final String name;

  const ProfileView({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0056B3),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Profil",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Column(
        children: [
          // ================= HEADER =================
          _header(),

          const SizedBox(height: 25),

          // ================= MENU =================
          _menuItem(context, Icons.edit, "Edit Profil"),
          _menuItem(context, Icons.help_outline, "Bantuan"),
          _menuItem(context, Icons.info_outline, "Tentang"),

          const SizedBox(height: 20),

          _menuItem(
            context,
            Icons.logout,
            "Logout",
            isLogout: true,
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        30,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0056B3),
            Color(0xFF2F80ED),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            child: const CircleAvatar(
              radius: 38,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 42,
                color: Colors.blue,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            name,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "user@email.com",
            style: GoogleFonts.poppins(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // ================= MENU ITEM =================
  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title, {
    bool isLogout = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        if (isLogout) {
          _confirmLogout(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout
                  ? Colors.red
                  : Colors.blue,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: isLogout
                      ? Colors.red
                      : Colors.black,
                ),
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  // ================= LOGOUT =================
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Konfirmasi",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Apakah kamu yakin ingin logout?",
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: Text(
              "Batal",
              style: GoogleFonts.poppins(),
            ),
          ),
          TextButton(
            onPressed: () async {
              final prefs =
                  await SharedPreferences
                      .getInstance();

              await prefs.clear();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LoginView(),
                ),
                (route) => false,
              );
            },
            child: Text(
              "Logout",
              style: GoogleFonts.poppins(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}