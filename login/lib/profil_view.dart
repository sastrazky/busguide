import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';
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
  State<ProfileView> createState() =>
      _ProfileViewState();
}

class _ProfileViewState
    extends State<ProfileView> {

  User? user;

  String? localImage;

  @override
  void initState() {
    super.initState();

    _loadUser();
  }

  // ================= LOAD USER =================
  Future<void> _loadUser() async {

    await FirebaseAuth.instance
        .currentUser
        ?.reload();

    final prefs =
        await SharedPreferences
            .getInstance();

    setState(() {

      user =
          FirebaseAuth.instance
              .currentUser;

      localImage =
          prefs.getString(
        "profile_image",
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7F9),

      appBar: AppBar(
        elevation: 0,

        backgroundColor:
            const Color(0xFF0056B3),

        iconTheme:
            const IconThemeData(
          color: Colors.white,
        ),

        title: Text(
          "Profil",

          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),

      body: Column(
        children: [

          // ================= HEADER =================
          _header(context),

          const SizedBox(height: 25),

          // ================= MENU =================
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
      ),
    );
  }

  // ================= HEADER =================
  Widget _header(
    BuildContext context,
  ) {

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
          bottomLeft:
              Radius.circular(30),

          bottomRight:
              Radius.circular(30),
        ),
      ),

      child: Column(
        children: [

          // ================= FOTO PROFILE =================
          GestureDetector(

            onTap: () {

              if (localImage == null &&
                  user?.photoURL == null) {
                return;
              }

              showGeneralDialog(
                context: context,

                barrierDismissible: true,

                barrierLabel: "Preview",

                barrierColor:
                    Colors.transparent,

                transitionDuration:
                    const Duration(
                  milliseconds: 450,
                ),

                pageBuilder:
                    (_, __, ___) {

                  return SafeArea(
                    child: GestureDetector(

                      onTap: () {
                        Navigator.pop(
                            context);
                      },

                      child: Stack(
                        children: [

                          // ================= BLUR BACKGROUND =================
                          BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 25,
                              sigmaY: 25,
                            ),

                            child: Container(
                              width:
                                  double.infinity,

                              height:
                                  double.infinity,

                              decoration:
                                  BoxDecoration(
                                gradient:
                                    LinearGradient(
                                  begin:
                                      Alignment
                                          .topLeft,

                                  end:
                                      Alignment
                                          .bottomRight,

                                  colors: [

                                    const Color(
                                      0xFF1565C0,
                                    ).withOpacity(
                                        0.85),

                                    const Color(
                                      0xFF42A5F5,
                                    ).withOpacity(
                                        0.75),

                                    Colors.white
                                        .withOpacity(
                                      0.55,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // ================= IMAGE =================
                          Center(
                            child:
                                GestureDetector(
                              onTap: () {},

                              child: Hero(
                                tag:
                                    "profile_photo",

                                child:
                                    Container(
                                  decoration:
                                      BoxDecoration(
                                    shape:
                                        BoxShape
                                            .circle,

                                    boxShadow: [

                                      BoxShadow(
                                        color: Colors
                                            .white
                                            .withOpacity(
                                                0.5),

                                        blurRadius:
                                            50,

                                        spreadRadius:
                                            8,
                                      ),

                                      BoxShadow(
                                        color: Colors
                                            .blue
                                            .withOpacity(
                                                0.4),

                                        blurRadius:
                                            40,
                                      ),
                                    ],
                                  ),

                                  child:
                                      InteractiveViewer(
                                    minScale:
                                        1,

                                    maxScale:
                                        4,

                                    child:
                                        CircleAvatar(
                                      radius:
                                          140,

                                      backgroundImage:
                                          localImage != null
                                              ? FileImage(
                                                  File(
                                                    localImage!,
                                                  ),
                                                )
                                              : NetworkImage(
                                                  user!
                                                      .photoURL!,
                                                ) as ImageProvider,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },

                transitionBuilder:
                    (_,
                        animation,
                        __,
                        child) {

                  return TweenAnimationBuilder(
                    tween:
                        Tween<double>(
                      begin: 0,
                      end: 1,
                    ),

                    duration:
                        const Duration(
                      milliseconds:
                          450,
                    ),

                    curve:
                        Curves.easeOutExpo,

                    builder:
                        (
                      context,
                      value,
                      _,
                    ) {

                      return Transform.scale(
                        scale:
                            0.85 +
                                (0.15 *
                                    value),

                        child: Opacity(
                          opacity: value,

                          child:
                              Transform.translate(
                            offset:
                                Offset(
                              0,
                              30 *
                                  (1 -
                                      value),
                            ),

                            child:
                                child,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },

            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,

                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),

              child: CircleAvatar(
                radius: 38,

                backgroundColor:
                    Colors.white,

                backgroundImage:
                    localImage != null
                        ? FileImage(
                            File(localImage!),
                          )
                        : user?.photoURL != null
                            ? NetworkImage(
                                user!.photoURL!,
                              )
                            : null,

                child:
                    localImage == null &&
                            user?.photoURL ==
                                null
                        ? const Icon(
                            Icons.person,
                            size: 42,
                            color:
                                Colors.blue,
                          )
                        : null,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ================= NAMA =================
          Text(
            user?.displayName ??
                widget.name,

            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 19,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          // ================= EMAIL =================
          Text(
            user?.email ??
                "user@email.com",

            style: GoogleFonts.poppins(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title, {
    bool isLogout = false,
  }) {

    return InkWell(
      borderRadius:
          BorderRadius.circular(14),

      onTap: () async {

        if (title == "Bantuan") {

          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) =>
                  BantuanView(),
            ),
          );
        }

        if (title == "Tentang") {

          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) =>
                  TentangView(),
            ),
          );
        }

        if (title ==
            "Edit Profil") {

          await Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) =>
                  const EditProfileView(),
            ),
          );

          await _loadUser();
        }

        if (isLogout) {
          _confirmLogout(context);
        }
      },

      child: Container(
        margin:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),

        padding:
            const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
                  14),

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

                style:
                    GoogleFonts.poppins(
                  fontWeight:
                      FontWeight.w500,

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

  void _confirmLogout(
      BuildContext context) {

    showDialog(
      context: context,

      builder: (_) => AlertDialog(
        title: Text(
          "Konfirmasi",

          style: GoogleFonts.poppins(
            fontWeight:
                FontWeight.w600,
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

              style:
                  GoogleFonts.poppins(),
            ),
          ),

          TextButton(
            onPressed: () async {

              await FirebaseAuth.instance
                  .signOut();

              final prefs =
                  await SharedPreferences
                      .getInstance();

              await prefs.clear();

              Navigator.pushAndRemoveUntil(
                context,

                MaterialPageRoute(
                  builder: (context) =>
                      const LoginView(),
                ),

                (route) => false,
              );
            },

            child: Text(
              "Logout",

              style:
                  GoogleFonts.poppins(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}