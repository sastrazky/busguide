import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/login_controller.dart';
import 'lupa_sandi_view.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildForm(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0056B3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.directions_bus,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(width: 10),
          Text(
            'Bus Guide',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ================= FORM =================
  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        24,
      ),
      child: Form(
        key: _controller.formKey,
        child: Column(
          children: [
            Image.asset(
              "assets/login_bus.jpeg",
              height: 180,
            ),
            const SizedBox(height: 20),

            // ================= TITLE =================
            Text(
              'Selamat Datang\nDi Bus Guide',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0056B3),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 25),

            _buildEmailField(),
            const SizedBox(height: 16),
            _buildPasswordField(),
            const SizedBox(height: 10),
            _buildForgotPassword(),
            const SizedBox(height: 10),
            
            _controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildLoginButton(),
            const SizedBox(height: 20),
            _buildDivider(),
            const SizedBox(height: 20),
            _buildGoogleButton(),
            const SizedBox(height: 16),
            _buildRegister(context),
          ],
        ),
      ),
    );
  }

  // ================= EMAIL =================
  Widget _buildEmailField() {
    return TextFormField(
      controller: _controller.emailController,
      style: GoogleFonts.poppins(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email tidak boleh kosong';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.account_circle,
        ),
        hintText: 'EmailAnda@gmail.com',
        hintStyle: GoogleFonts.poppins(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ================= PASSWORD =================
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _controller.passwordController,
      obscureText: _controller.obscurePassword,
      style: GoogleFonts.poppins(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password tidak boleh kosong';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.lock,
        ),
        hintText: 'Masukkan Sandi',
        hintStyle: GoogleFonts.poppins(),
        suffixIcon: IconButton(
          icon: Icon(
            _controller.obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: _controller.togglePasswordVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ================= FORGOT PASSWORD =================
  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ForgotPasswordView(),
            ),
          );
        },
        child: Text(
          "Lupa sandi?",
          style: GoogleFonts.poppins(),
        ),
      ),
    );
  }

  // ================= LOGIN BUTTON =================
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => _controller.login(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0056B3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'MASUK',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ================= DIVIDER =================
  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text(
            "ATAU",
            style: GoogleFonts.poppins(
              color: Colors.grey,
            ),
          ),
        ),
        const Expanded(
          child: Divider(),
        ),
      ],
    );
  }

  // ================= GOOGLE BUTTON =================
  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () => _controller.loginWithGoogle(context),
              icon: Image.asset(
        'assets/google_logo1.png',
        width: 24,
        height: 24,
      ),
        label: Text(
          "Masuk dengan Google",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Colors.grey,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ================= REGISTER =================
  Widget _buildRegister(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Belum punya akun? ",
          style: GoogleFonts.poppins(
            fontSize: 12,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterView(),
              ),
            );
          },
          child: Text(
            'Daftar Sekarang',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
