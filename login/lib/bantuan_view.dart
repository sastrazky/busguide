import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BantuanView extends StatelessWidget {
  const BantuanView({super.key});

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
          "Pusat Bantuan",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // ================= HEADER =================
            Container(
              width: double.infinity,

              padding: const EdgeInsets.fromLTRB(
                20,
                24,
                20,
                35,
              ),

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0056B3),
                    Color(0xFF2F80ED),
                  ],
                ),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),

              child: Column(
                children: [

                  // ================= ICON =================
                  Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color:
                          Colors.white.withOpacity(
                        0.15,
                      ),

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.help_outline_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ================= TITLE =================
                  Text(
                    "Pusat Bantuan",
                    textAlign: TextAlign.center,

                    style: GoogleFonts.poppins(
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
                    textAlign: TextAlign.center,

                    style: GoogleFonts.poppins(
                      color:
                          Colors.white.withOpacity(
                        0.9,
                      ),

                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= FAQ =================
            _faqItem(
              "Bagaimana cara mengubah foto profil?",
              "Masuk ke menu Edit Profil lalu tekan foto profil untuk mengganti gambar baru.",
            ),

            _faqItem(
              "Bagaimana cara mengubah nama akun?",
              "Buka halaman Edit Profil kemudian ubah nama sesuai keinginan lalu simpan perubahan.",
            ),

            _faqItem(
              "Kenapa aplikasi terasa lambat?",
              "Pastikan koneksi internet stabil dan gunakan versi aplikasi terbaru.",
            ),

            _faqItem(
              "Bagaimana cara logout akun?",
              "Masuk ke halaman Profil lalu tekan tombol Logout di bagian bawah.",
            ),

            _faqItem(
              "Apakah data akun saya aman?",
              "Ya, data akun dilindungi dengan sistem keamanan dan autentikasi Firebase.",
            ),

            _faqItem(
              "Bagaimana jika lupa password?",
              "Gunakan fitur lupa password pada halaman login untuk mereset password akun.",
            ),

            _faqItem(
              "Bagaimana cara mengganti email akun?",
              "Masuk ke menu Edit Profil lalu ubah email akun dan simpan perubahan.",
            ),

            _faqItem(
              "Kenapa foto profil tidak muncul?",
              "Periksa koneksi internet dan coba refresh halaman profil kembali.",
            ),

            _faqItem(
              "Apakah aplikasi bisa digunakan tanpa internet?",
              "Beberapa fitur membutuhkan koneksi internet agar dapat berjalan dengan baik.",
            ),

            _faqItem(
              "Bagaimana cara memperbarui aplikasi?",
              "Buka Play Store atau App Store lalu cari aplikasi ini dan tekan tombol update.",
            ),

            _faqItem(
              "Kenapa saya gagal login?",
              "Pastikan email dan password sudah benar serta koneksi internet stabil.",
            ),

            _faqItem(
              "Bagaimana cara menghapus akun?",
              "Saat ini penghapusan akun hanya dapat dilakukan melalui pengaturan akun tertentu.",
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

            _faqItem(
              "Bagaimana cara mengganti password?",
              "Masuk ke pengaturan akun lalu pilih opsi ubah password.",
            ),

            _faqItem(
              "Kenapa notifikasi tidak muncul?",
              "Pastikan izin notifikasi aplikasi sudah diaktifkan di pengaturan perangkat.",
            ),

            const SizedBox(height: 30),

            // ================= FOOTER =================
            Text(
              "© 2025 My Application",
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ================= FAQ ITEM =================
  Widget _faqItem(
    String question,
    String answer,
  ) {

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.04,
            ),

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
          style: GoogleFonts.poppins(
            fontWeight:
                FontWeight.w600,
            fontSize: 14,
          ),
        ),

        children: [
          Align(
            alignment: Alignment.centerLeft,

            child: Text(
              answer,
              style: GoogleFonts.poppins(
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