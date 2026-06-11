import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/profile_controller.dart';
import 'edit_profile_view.dart';
import 'bantuan_view.dart';
import 'tentang_view.dart';

class ProfileView extends StatefulWidget {
  final String name;

  const ProfileView({
    super.key,
    required this.name,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileController(
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );
    _controller.loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 25),
          _buildMenuList(context),
        ],
      ),
    );
  }

  // ================= APP BAR =================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF0056B3),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      title: Text(
        "Profil",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0056B3),
            Color(0xFF2F80ED),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfilePhoto(context),
          const SizedBox(height: 12),
          _buildName(),
          const SizedBox(height: 4),
          _buildEmail(),
        ],
      ),
    );
  }

  // ================= PROFILE PHOTO =================
  Widget _buildProfilePhoto(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller.localImage == null) {
          return;
        }
        _showImagePreview(context);
      },
      child: Hero(
        tag: "profile_photo",
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 12,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 38,
            backgroundColor: Colors.white,
            backgroundImage: _controller.localImage != null
                ? FileImage(File(_controller.localImage!))
                : null,
            child: _controller.localImage == null
                ? const Icon(
                    Icons.person,
                    size: 42,
                    color: Colors.blue,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  // ================= NAME =================
  Widget _buildName() {
    return Text(
      _controller.name.isNotEmpty ? _controller.name : widget.name,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 19,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ================= EMAIL =================
  Widget _buildEmail() {
    return Text(
      _controller.user?.email ?? "user@email.com",
      style: GoogleFonts.poppins(
        color: Colors.white70,
      ),
    );
  }

  // ================= MENU LIST =================
  Widget _buildMenuList(BuildContext context) {
    return Column(
      children: [
        _menuItem(
          context,
          Icons.edit,
          "Edit Profil",
        ),
        _menuItem(
          context,
          Icons.help_outline,
          "Bantuan",
        ),
        _menuItem(
          context,
          Icons.info_outline,
          "Tentang",
        ),
        const SizedBox(height: 20),
        _menuItem(
          context,
          Icons.logout,
          "Logout",
          isLogout: true,
        ),
      ],
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
      onTap: () async {
        if (title == "Bantuan") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BantuanView(),
            ),
          );
        } else if (title == "Tentang") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TentangView(),
            ),
          );
        } else if (title == "Edit Profil") {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditProfileView(),
            ),
          );
          await _controller.loadUser();
        } else if (isLogout) {
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
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? Colors.red : Colors.blue,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: isLogout ? Colors.red : Colors.black,
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

  // ================= IMAGE PREVIEW =================
  void _showImagePreview(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Preview",
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (_, __, ___) {
        return SafeArea(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Stack(
              children: [
                _buildBlurBackground(),
                _buildPreviewImage(),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutExpo,
          builder: (context, value, _) {
            return Transform.scale(
              scale: 0.85 + (0.15 * value),
              child: Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: child,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ================= BLUR BACKGROUND =================
  Widget _buildBlurBackground() {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 25,
        sigmaY: 25,
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1565C0).withOpacity(0.85),
              const Color(0xFF42A5F5).withOpacity(0.75),
              Colors.white.withOpacity(0.55),
            ],
          ),
        ),
      ),
    );
  }

  // ================= PREVIEW IMAGE =================
  Widget _buildPreviewImage() {
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: Hero(
          tag: "profile_photo",
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  blurRadius: 50,
                  spreadRadius: 8,
                ),
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 40,
                ),
              ],
            ),
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: CircleAvatar(
                radius: 140,
                backgroundImage: _controller.localImage != null
                    ? FileImage(File(_controller.localImage!))
                    : null,
                child: _controller.localImage == null
                    ? const Icon(
                        Icons.person,
                        size: 120,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
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
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Batal",
              style: GoogleFonts.poppins(),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _controller.signOut(context);
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
