import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/register_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({
    super.key,
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final RegisterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterController(
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );
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
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildFormCard(context),
          ],
        ),
      ),
    );
  }

  // ================= APP BAR =================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0056B3),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      title: Text(
        "Daftar",
        style: GoogleFonts.poppins(
          color: Colors.white,
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Buat Akun Baru",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0056B3),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Daftar untuk mulai menggunakan aplikasi",
          style: GoogleFonts.poppins(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // ================= FORM CARD =================
  Widget _buildFormCard(BuildContext context) {
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
      child: Form(
        key: _controller.formKey,
        child: Column(
          children: [
            // ================= NAME =================
            _inputField(
              controller: _controller.nameController,
              label: "Nama",
              icon: Icons.person,
              validator: (v) => (v == null || v.isEmpty) ? "Nama tidak boleh kosong" : null,
            ),
            const SizedBox(height: 16),

            // ================= EMAIL =================
            _inputField(
              controller: _controller.emailController,
              label: "Email",
              icon: Icons.email,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return "Email tidak boleh kosong";
                }
                if (!v.contains("@gmail.com")) {
                  return "Email harus menggunakan @gmail.com";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ================= PASSWORD =================
            _inputField(
              controller: _controller.passwordController,
              label: "Kata Sandi",
              icon: Icons.lock,
              obscure: _controller.obscurePassword,
              toggle: _controller.togglePasswordVisibility,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return "Kata Sandi tidak boleh kosong";
                }
                if (v.length < 6) {
                  return "Minimal 6 karakter";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ================= CONFIRM PASSWORD =================
            _inputField(
              controller: _controller.confirmPasswordController,
              label: "Konfirmasi Kata Sandi",
              icon: Icons.lock_outline,
              obscure: _controller.obscureConfirmPassword,
              toggle: _controller.toggleConfirmPasswordVisibility,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return "Konfirmasi Kata Sandi tidak boleh kosong";
                }
                if (v != _controller.passwordController.text) {
                  return "Kata Sandi tidak cocok";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ================= AGREEMENT =================
            _buildAgreement(),
            const SizedBox(height: 10),

            // ================= BUTTON =================
            _controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildRegisterButton(),
            const SizedBox(height: 10),

            // ================= LOGIN =================
            _buildLoginButton(context),
          ],
        ),
      ),
    );
  }

  // ================= AGREEMENT =================
  Widget _buildAgreement() {
    return Row(
      children: [
        Checkbox(
          value: _controller.agree,
          onChanged: (val) => _controller.setAgreement(val ?? false),
        ),
        Expanded(
          child: Text(
            "Saya setuju dengan syarat & ketentuan",
            style: GoogleFonts.poppins(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  // ================= REGISTER BUTTON =================
  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => _controller.register(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0056B3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "Daftar",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ================= LOGIN BUTTON =================
  Widget _buildLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        "Sudah punya akun? Masuk",
        style: GoogleFonts.poppins(),
      ),
    );
  }

  // ================= INPUT FIELD =================
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool obscure = false,
    VoidCallback? toggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(),
        prefixIcon: Icon(icon),
        suffixIcon: toggle != null
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: toggle,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
