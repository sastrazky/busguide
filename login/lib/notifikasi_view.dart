import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotifikasiView extends StatelessWidget {
  const NotifikasiView({super.key});

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
          "Notifikasi",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            _notifCard(
              Icons.directions_bus,
              "Perubahan Rute",
              "Rute R05 mengalami perubahan jalur mulai besok.",
              "5 menit lalu",
              Colors.blue,
            ),

            _notifCard(
              Icons.access_time,
              "Keterlambatan Bus",
              "Bus tujuan Terminal B mengalami keterlambatan 10 menit.",
              "20 menit lalu",
              Colors.orange,
            ),

            _notifCard(
              Icons.location_on,
              "Halte Baru",
              "Halte baru telah ditambahkan di area pusat kota.",
              "1 jam lalu",
              Colors.green,
            ),

            _notifCard(
              Icons.info_outline,
              "Informasi Sistem",
              "Aplikasi berhasil diperbarui ke versi terbaru.",
              "Hari ini",
              Colors.purple,
            ),

            _notifCard(
              Icons.notifications_active,
              "Pengingat",
              "Jangan lupa cek jadwal keberangkatan bus hari ini.",
              "Hari ini",
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  // ================= CARD =================
  Widget _notifCard(
    IconData icon,
    String title,
    String subtitle,
    String time,
    Color color,
  ) {

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.04),

            blurRadius: 10,
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // ================= ICON =================
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 14),

          // ================= TEXT =================
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight:
                        FontWeight.w600,

                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[700],
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  time,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}