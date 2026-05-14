import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState
    extends State<EditProfileView> {

  final TextEditingController
      _nameController =
      TextEditingController();

  final TextEditingController
      _emailController =
      TextEditingController();

  bool isLoading = false;

  File? selectedImage;

  User? user;

  @override
  void initState() {
    super.initState();

    _loadUserData();
  }

  // ================= LOAD USER =================
  Future<void> _loadUserData() async {

    user =
        FirebaseAuth.instance
            .currentUser;

    final prefs =
        await SharedPreferences
            .getInstance();

    final imagePath =
        prefs.getString(
      "profile_image",
    );

    if (user != null) {

      _nameController.text =
          user!.displayName ?? "";

      _emailController.text =
          user!.email ?? "";
    }

    if (imagePath != null) {

      setState(() {
        selectedImage =
            File(imagePath);
      });
    }
  }

  // ================= PICK IMAGE =================
  Future<void> _pickImage() async {

    final ImagePicker picker =
        ImagePicker();

    final XFile? image =
        await picker.pickImage(

      source: ImageSource.gallery,

      imageQuality: 85,

      maxWidth: 1080,
      maxHeight: 1080,

      requestFullMetadata: false,
    );

    if (image == null) return;

    String path =
        image.path.toLowerCase();

    if (!(path.endsWith(".png") ||
        path.endsWith(".jpg") ||
        path.endsWith(".jpeg"))) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Format harus PNG/JPG/JPEG",
            style:
                GoogleFonts.poppins(),
          ),
        ),
      );

      return;
    }

    setState(() {
      selectedImage =
          File(image.path);
    });
  }

  // ================= SAVE PROFILE =================
  Future<void> _saveProfile() async {

    try {

      setState(() {
        isLoading = true;
      });

      final user =
          FirebaseAuth.instance.currentUser;

      if (user != null) {

        // ================= UPDATE NAMA =================
        await user.updateDisplayName(
          _nameController.text,
        );

        // ================= SIMPAN FOTO =================
        if (selectedImage != null) {

          final prefs =
              await SharedPreferences
                  .getInstance();

          await prefs.setString(
            "profile_image",
            selectedImage!.path,
          );
        }

        // ================= UPDATE FIRESTORE =================
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'name':
              _nameController.text,
          'email':
              _emailController.text,
        }, SetOptions(merge: true));

        // ================= REFRESH USER =================
        await user.reload();

        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              "Profil berhasil diperbarui",
              style:
                  GoogleFonts.poppins(),
            ),
          ),
        );

        Navigator.pop(context);
      }

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
          ),
        ),
      );

    } finally {

      setState(() {
        isLoading = false;
      });
    }
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
          "Edit Profil",

          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(24),

        child: Column(
          children: [

            // ================= CARD PROFILE =================
            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                        24),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.05),

                    blurRadius: 15,
                  ),
                ],
              ),

              child: Column(
                children: [

                  // ================= FOTO =================
                  Stack(
                    children: [

                      GestureDetector(
                        onTap: _pickImage,

                        child: CircleAvatar(
                          radius: 55,

                          backgroundColor:
                              Colors.white,

                          backgroundImage:
                              selectedImage !=
                                      null
                                  ? FileImage(
                                      selectedImage!,
                                    )
                                  : user?.photoURL !=
                                          null
                                      ? NetworkImage(
                                          user!
                                              .photoURL!,
                                        )
                                      : null,

                          child:
                              selectedImage ==
                                          null &&
                                      user?.photoURL ==
                                          null
                                  ? const Icon(
                                      Icons.person,
                                      size: 60,
                                      color:
                                          Colors.blue,
                                    )
                                  : null,
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,

                        child: InkWell(
                          onTap: _pickImage,

                          child: Container(
                            padding:
                                const EdgeInsets
                                    .all(8),

                            decoration:
                                const BoxDecoration(
                              color: Color(
                                  0xFF0056B3),

                              shape:
                                  BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.camera_alt,
                              color:
                                  Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Foto Profil",

                    style:
                        GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Ambil foto dari galeri",

                    style:
                        GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ================= FORM =================
            Container(
              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                        24),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.05),

                    blurRadius: 15,
                  ),
                ],
              ),

              child: Column(
                children: [

                  // ================= NAMA =================
                  TextField(
                    controller:
                        _nameController,

                    decoration:
                        InputDecoration(
                      labelText: "Nama",

                      prefixIcon:
                          const Icon(
                        Icons.person,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ================= EMAIL =================
                  TextField(
                    controller:
                        _emailController,

                    enabled: false,

                    decoration:
                        InputDecoration(
                      labelText: "Email",

                      prefixIcon:
                          const Icon(
                        Icons.email,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ================= BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : _saveProfile,

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF0056B3,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            18),
                  ),
                ),

                child:
                    isLoading
                        ? const CircularProgressIndicator(
                            color:
                                Colors.white,
                          )
                        : Text(
                            "Simpan Perubahan",

                            style:
                                GoogleFonts
                                    .poppins(
                              color:
                                  Colors.white,

                              fontSize: 16,

                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}