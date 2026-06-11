import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({
    super.key,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final EditProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EditProfileController(
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );
    _controller.loadUserData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0056B3),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Edit Profil",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _controller.formKey,
                child: Column(
                  children: [
                    _buildFormCard(),
                    const SizedBox(height: 30),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
    );
  }

  // ================= CARD FORM =================
  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        children: [
          // Nama Field
          TextFormField(
            controller: _controller.nameController,
            style: GoogleFonts.poppins(),
            validator: (v) {
              if (v == null || v.isEmpty) {
                return 'Nama tidak boleh kosong';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Nama Lengkap",
              labelStyle: GoogleFonts.poppins(),
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Email Field (Read Only)
          TextFormField(
            controller: _controller.emailController,
            enabled: false,
            style: GoogleFonts.poppins(color: Colors.grey),
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: GoogleFonts.poppins(),
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= BUTTON SIMPAN =================
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => _controller.saveProfile(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0056B3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Simpan Perubahan',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
