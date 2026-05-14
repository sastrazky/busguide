import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ================= FIREBASE =================
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() =>
      _RegisterViewState();
}

class _RegisterViewState
    extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController
      _emailController =
      TextEditingController();

  final TextEditingController
      _passwordController =
      TextEditingController();

  final TextEditingController
      _confirmPasswordController =
      TextEditingController();

  bool agree = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  // ================= REGISTER =================
  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ??
        false)) {
      return;
    }

    if (!agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Harus menyetujui syarat & ketentuan",
          ),
        ),
      );
      return;
    }

    try {
      // ================= REGISTER FIREBASE =================
      UserCredential userCredential =
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password:
            _passwordController.text.trim(),
      );

      // ================= SIMPAN DATA USER =================
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': _nameController.text.trim(),
        'email':
            _emailController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      // ================= SUCCESS =================
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Registrasi berhasil",
          ),
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? "Terjadi error",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7F9),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF0056B3),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Daftar",
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ================= HEADER =================
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Buat Akun Baru",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      const Color(0xFF0056B3),
                ),
              ),
            ),

            const SizedBox(height: 6),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Daftar untuk mulai menggunakan aplikasi",
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= FORM CARD =================
            Container(
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                        20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.05),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ===== NAME =====
                    _inputField(
                      controller:
                          _nameController,
                      label: "Nama",
                      icon: Icons.person,
                      validator: (v) =>
                          (v == null ||
                                  v.isEmpty)
                              ? "Nama tidak boleh kosong"
                              : null,
                    ),

                    const SizedBox(
                        height: 16),

                    // ===== EMAIL =====
                    _inputField(
                      controller:
                          _emailController,
                      label: "Email",
                      icon: Icons.email,
                      validator: (v) {
                        if (v == null ||
                            v.isEmpty) {
                          return "Email tidak boleh kosong";
                        }

                        if (!v.contains("@")) {
                          return "Email tidak valid";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                        height: 16),

                    // ===== PASSWORD =====
                    _inputField(
                      controller:
                          _passwordController,
                      label: "Password",
                      icon: Icons.lock,
                      obscure:
                          obscurePassword,
                      toggle: () {
                        setState(() {
                          obscurePassword =
                              !obscurePassword;
                        });
                      },
                      validator: (v) {
                        if (v == null ||
                            v.isEmpty) {
                          return "Password tidak boleh kosong";
                        }

                        if (v.length < 6) {
                          return "Minimal 6 karakter";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                        height: 16),

                    // ===== CONFIRM PASSWORD =====
                    _inputField(
                      controller:
                          _confirmPasswordController,
                      label:
                          "Konfirmasi Password",
                      icon:
                          Icons.lock_outline,
                      obscure:
                          obscureConfirmPassword,
                      toggle: () {
                        setState(() {
                          obscureConfirmPassword =
                              !obscureConfirmPassword;
                        });
                      },
                      validator: (v) {
                        if (v == null ||
                            v.isEmpty) {
                          return "Konfirmasi password tidak boleh kosong";
                        }

                        if (v !=
                            _passwordController
                                .text) {
                          return "Password tidak cocok";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                        height: 16),

                    // ===== AGREEMENT =====
                    Row(
                      children: [
                        Checkbox(
                          value: agree,
                          onChanged: (val) {
                            setState(() {
                              agree =
                                  val ??
                                      false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            "Saya setuju dengan syarat & ketentuan",
                            style:
                                GoogleFonts
                                    .poppins(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 10),

                    // ===== BUTTON =====
                    SizedBox(
                      width:
                          double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            _register,
                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              const Color(
                            0xFF0056B3,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    12),
                          ),
                        ),
                        child: Text(
                          "Daftar",
                          style:
                              GoogleFonts
                                  .poppins(
                            color:
                                Colors.white,
                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    // ===== LOGIN =====
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(
                              context),
                      child: Text(
                        "Sudah punya akun? Masuk",
                        style:
                            GoogleFonts
                                .poppins(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= INPUT FIELD =================
  Widget _inputField({
    required TextEditingController
        controller,
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
        labelStyle:
            GoogleFonts.poppins(),
        prefixIcon: Icon(icon),
        suffixIcon: toggle != null
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons
                          .visibility_off
                      : Icons.visibility,
                ),
                onPressed: toggle,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
      ),
    );
  }
}