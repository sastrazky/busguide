import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_view.dart';
import 'register_view.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ================= LOGIN =================
  Future<void> _login() async {
    var url =
        Uri.parse("http://localhost/bus_app/login.php");

    var response = await http.post(
      url,
      body: {
        "email": _emailController.text,
        "password": _passwordController.text,
      },
    );

    var data = json.decode(response.body);

    if (data["status"] == "success") {
      final prefs =
          await SharedPreferences.getInstance();

      prefs.setBool('isLogin', true);
      prefs.setString('name', data["name"]);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeView(name: data["name"]),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data["message"]),
        ),
      );
    }
  }

  void _loginWithGoogle() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const HomeView(name: "Google User"),
      ),
    );
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
                  borderRadius:
                      BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ================= HEADER =================
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0056B3),
                        borderRadius: BorderRadius.only(
                          topLeft:
                              Radius.circular(20),
                          topRight:
                              Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
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
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ================= FORM =================
                    Padding(
                      padding:
                          const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/login_bus.jpeg",
                              height: 180,
                            ),

                            const SizedBox(height: 20),

                            Text(
                              'Selamat Datang di Bus guide',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.w600,
                                color:
                                    const Color(0xFF0056B3),
                              ),
                            ),

                            const SizedBox(height: 25),

                            // ===== EMAIL =====
                            TextFormField(
                              controller:
                                  _emailController,
                              style:
                                  GoogleFonts.poppins(),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(Icons
                                        .account_circle),
                                hintText:
                                    'EmailAnda@gmail.com',
                                hintStyle:
                                    GoogleFonts.poppins(),
                                border:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          12),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ===== PASSWORD =====
                            TextFormField(
                              controller:
                                  _passwordController,
                              obscureText:
                                  obscurePassword,
                              style:
                                  GoogleFonts.poppins(),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(
                                        Icons.lock),
                                hintText:
                                    'Masukkan sandi',
                                hintStyle:
                                    GoogleFonts.poppins(),

                                // ICON MATA
                                suffixIcon:
                                    IconButton(
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons
                                            .visibility_off
                                        : Icons
                                            .visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword =
                                          !obscurePassword;
                                    });
                                  },
                                ),

                                border:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          12),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // ===== LUPA PASSWORD =====
                            Align(
                              alignment:
                                  Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Lupa sandi?",
                                  style:
                                      GoogleFonts.poppins(),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // ===== BUTTON LOGIN =====
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton
                                    .styleFrom(
                                  backgroundColor:
                                      const Color(
                                          0xFF0056B3),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            12),
                                  ),
                                ),
                                child: Text(
                                  'MASUK',
                                  style: GoogleFonts.poppins(
                                    color:
                                        Colors.white,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ===== ATAU =====
                            Row(
                              children: [
                                const Expanded(
                                    child: Divider()),
                                Padding(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                              horizontal:
                                                  10),
                                  child: Text(
                                    "ATAU",
                                    style: GoogleFonts
                                        .poppins(
                                            color: Colors
                                                .grey),
                                  ),
                                ),
                                const Expanded(
                                    child: Divider()),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // ===== GOOGLE =====
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child:
                                  OutlinedButton.icon(
                                onPressed:
                                    _loginWithGoogle,
                                icon: const Icon(
                                  Icons.login,
                                  color: Colors.red,
                                ),
                                label: Text(
                                  "Masuk dengan Google",
                                  style:
                                      GoogleFonts.poppins(
                                    fontWeight:
                                        FontWeight.w600,
                                    color:
                                        Colors.black87,
                                  ),
                                ),
                                style:
                                    OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color:
                                          Colors.grey),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            12),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ===== REGISTER =====
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Belum punya akun? ",
                                  style: GoogleFonts
                                      .poppins(
                                          fontSize: 12),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const RegisterView(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Daftar Sekarang',
                                    style:
                                        GoogleFonts
                                            .poppins(
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}