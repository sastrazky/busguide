import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BantuanView extends StatelessWidget {
  const BantuanView({super.key});

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
          "Pusat Bantuan",

          style:
              GoogleFonts.poppins(
            color: Colors.white,

            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(
          bottom: 20,
        ),

        child: Column(
          children: [

            _buildHeader(),

            const SizedBox(height: 20),

            _buildFaqList(),

            const SizedBox(height: 18),

            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {

    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        35,
      ),

      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          begin:
              Alignment.topLeft,

          end:
              Alignment.bottomRight,

          colors: [
            Color(0xFF0056B3),
            Color(0xFF2F80ED),
          ],
        ),

        borderRadius:
            const BorderRadius.only(
          bottomLeft:
              Radius.circular(35),

          bottomRight:
              Radius.circular(35),
        ),

        // ================= SHADOW =================
        boxShadow: [

          BoxShadow(
            color: Colors.black
                .withOpacity(0.10),

            blurRadius: 12,

            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Column(
        children: [

          // ================= ICON =================
          Container(
            padding:
                const EdgeInsets.all(
                    18),

            decoration: BoxDecoration(
              color: Colors.white
                  .withOpacity(
                0.15,
              ),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons
                  .help_outline_rounded,

              color: Colors.white,
              size: 38,
            ),
          ),

          const SizedBox(height: 18),

          // ================= TITLE =================
          Text(
            "Pusat Bantuan",

            textAlign:
                TextAlign.center,

            style:
                GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 26,

              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          // ================= SUBTITLE =================
          Text(
            "Temukan jawaban cepat untuk berbagai pertanyaan dan informasi seputar aplikasi.",

            textAlign:
                TextAlign.center,

            style:
                GoogleFonts.poppins(
              color: Colors.white
                  .withOpacity(
                0.9,
              ),

              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ================= FAQ LIST =================
  Widget _buildFaqList() {

    return Column(
      children: [

        _faqItem(
          "Bagaimana cara mengubah nama akun?",
          "Buka halaman Edit Profil kemudian ubah nama sesuai keinginan lalu simpan perubahan.",
        ),

        _faqItem(
          "Bagaimana cara logout akun?",
          "Masuk ke halaman Profil lalu tekan tombol Logout di bagian bawah.",
        ),

        _faqItem(
          "Apakah data akun saya aman?",
          "Ya, data akun dilindungi dengan sistem keamanan dan autentikasi Supabase.",
        ),

        _faqItem(
          "Bagaimana jika lupa kata sandi?",
          "Gunakan fitur lupa sandi pada halaman login untuk mereset kata sandi akun.",
        ),

        _faqItem(
          "Apakah aplikasi bisa digunakan tanpa internet?",
          "Beberapa fitur membutuhkan koneksi internet agar dapat berjalan dengan baik.",
        ),

        _faqItem(
          "Kenapa saya gagal login?",
          "Pastikan email dan kata sandi sudah benar serta koneksi internet stabil.",
        ),

        _faqItem(
          "Apakah aplikasi ini gratis digunakan?",
          "Ya, seluruh fitur utama aplikasi dapat digunakan secara gratis.",
        ),

        _faqItem(
          "Kenapa aplikasi keluar sendiri?",
          "Coba tutup aplikasi lalu buka kembali atau gunakan versi aplikasi terbaru.",
        ),

        _faqItem(
          "Bagaimana cara menghubungi pengembang?",
          "Informasi pengembang dapat dilihat pada halaman Tentang aplikasi.",
        ),

        _faqItem(
          "Apakah data saya tersimpan otomatis?",
          "Sebagian besar perubahan data akan tersimpan otomatis setelah berhasil diperbarui.",
        ),

      ],
    );
  }

  // ================= FOOTER =================
  Widget _buildFooter() {

    return Column(
      children: [

        Text(
          "© 2026 Bus Guide App",

          style:
              GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          "All rights reserved",

          style:
              GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ================= FAQ ITEM =================
  Widget _faqItem(
    String question,
    String answer,
  ) {

    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(
            color: Colors.black
                .withOpacity(0.04),

            blurRadius: 10,
          ),
        ],
      ),

      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 4,
        ),

        childrenPadding:
            const EdgeInsets.fromLTRB(
          18,
          0,
          18,
          18,
        ),

        iconColor:
            const Color(0xFF0056B3),

        collapsedIconColor:
            const Color(0xFF0056B3),

        title: Text(
          question,

          style:
              GoogleFonts.poppins(
            fontWeight:
                FontWeight.w600,

            fontSize: 14,
          ),
        ),

        children: [
          Align(
            alignment:
                Alignment.centerLeft,

            child: Text(
              answer,

              style:
                  GoogleFonts.poppins(
                color: Colors.grey[700],
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}