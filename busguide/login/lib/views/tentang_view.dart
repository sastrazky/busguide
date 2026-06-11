import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TentangView extends StatelessWidget {

  const TentangView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7F9),

      appBar: _buildAppBar(),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          20,
        ),

        child: Column(
          children: [

            _buildHeader(),

            const SizedBox(height: 28),

            _buildFeatureSection(),

            const SizedBox(height: 28),

            _buildDeveloperSection(),

            const SizedBox(height: 28),

            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ================= APP BAR =================
  PreferredSizeWidget
      _buildAppBar() {

    return AppBar(
      elevation: 0,

      backgroundColor:
          const Color(
        0xFF0056B3,
      ),

      iconTheme:
          const IconThemeData(
        color: Colors.white,
      ),

      title: Text(
        "Tentang Aplikasi",

        style:
            GoogleFonts.poppins(
          color: Colors.white,

          fontWeight:
              FontWeight.w600,
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {

    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(
              28),

      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xFF0056B3),
            Color(0xFF2F80ED),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
                28),
      ),

      child: Column(
        children: [

          _buildLogo(),

          const SizedBox(height: 20),

          _buildAppTitle(),

          const SizedBox(height: 8),

          _buildVersion(),

          const SizedBox(height: 18),

          _buildDescription(),
        ],
      ),
    );
  }

  // ================= FEATURE SECTION =================
  Widget _buildFeatureSection() {

    return Column(
      children: [

        _sectionTitle(
          "Fitur Aplikasi",
        ),

        const SizedBox(height: 14),

        _featureItem(
          Icons.map,
          "Navigasi Rute",
          "Melihat rute perjalanan bus dengan mudah.",
        ),

        _featureItem(
          Icons.location_on,
          "Tracking Lokasi",
          "Mengetahui posisi dan tujuan perjalanan.",
        ),

        _featureItem(
          Icons.person,
          "Login Aplikasi",
          "Masuk menggunakan Google dan Email.",
        ),

        _featureItem(
          Icons.security,
          "Keamanan Akun",
          "Data akun tersimpan aman menggunakan Supabase.",
        ),
      ],
    );
  }

  // ================= DEVELOPER SECTION =================
  Widget _buildDeveloperSection() {

    return Column(
      children: [

        _sectionTitle(
          "Developer",
        ),

        const SizedBox(height: 14),

        Container(
          width: double.infinity,

          padding:
              const EdgeInsets.all(
                  20),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
                    22),

            boxShadow: [

              BoxShadow(
                color: Colors.black
                    .withOpacity(0.04),

                blurRadius: 12,
              ),
            ],
          ),

          child: Row(
            children: [

              _buildDeveloperAvatar(),

              const SizedBox(width: 18),

              _buildDeveloperInfo(),
            ],
          ),
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

  // ================= LOGO =================
  Widget _buildLogo() {

    return Container(
      width: 95,
      height: 95,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
                28),
      ),

      child: const Icon(
        Icons.directions_bus,

        size: 55,

        color:
            Color(
          0xFF0056B3,
        ),
      ),
    );
  }

  // ================= APP TITLE =================
  Widget _buildAppTitle() {

    return Text(
      "Bus Guide",

      style:
          GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 28,

        fontWeight:
            FontWeight.w700,
      ),
    );
  }

  // ================= VERSION =================
  Widget _buildVersion() {

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: Colors.white24,

        borderRadius:
            BorderRadius.circular(
                20),
      ),

      child: Text(
        "Versi 1.0.0",

        style:
            GoogleFonts.poppins(
          color: Colors.white,

          fontWeight:
              FontWeight.w500,
        ),
      ),
    );
  }

  // ================= DESCRIPTION =================
  Widget _buildDescription() {

    return Text(
      "Aplikasi panduan bus modern untuk membantu perjalanan lebih mudah, cepat, dan nyaman.",

      textAlign:
          TextAlign.center,

      style:
          GoogleFonts.poppins(
        color: Colors.white70,
        fontSize: 14,
      ),
    );
  }

  // ================= DEVELOPER AVATAR =================
  Widget _buildDeveloperAvatar() {

    return const CircleAvatar(
      radius: 32,

      backgroundColor:
          Color(
        0xFF0056B3,
      ),

      child: Icon(
        Icons.person,

        color: Colors.white,
        size: 35,
      ),
    );
  }

  // ================= DEVELOPER INFO =================
  Widget _buildDeveloperInfo() {

    return Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [

          Text(
            "Bus Guide Team",

            style:
                GoogleFonts.poppins(
              fontWeight:
                  FontWeight.w700,

              fontSize: 16,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Developer & Designer",

            style:
                GoogleFonts.poppins(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget _sectionTitle(
    String title,
  ) {

    return Align(
      alignment:
          Alignment.centerLeft,

      child: Text(
        title,

        style:
            GoogleFonts.poppins(
          fontSize: 19,

          fontWeight:
              FontWeight.w700,
        ),
      ),
    );
  }

  // ================= FEATURE ITEM =================
  Widget _featureItem(
    IconData icon,
    String title,
    String subtitle,
  ) {

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(
              18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
                22),

        boxShadow: [

          BoxShadow(
            color: Colors.black
                .withOpacity(0.04),

            blurRadius: 12,
          ),
        ],
      ),

      child: Row(
        children: [

          _buildFeatureIcon(
            icon,
          ),

          const SizedBox(width: 16),

          _buildFeatureText(
            title,
            subtitle,
          ),
        ],
      ),
    );
  }

  // ================= FEATURE ICON =================
  Widget _buildFeatureIcon(
    IconData icon,
  ) {

    return Container(
      padding:
          const EdgeInsets.all(
              14),

      decoration: BoxDecoration(
        color: const Color(
          0xFF0056B3,
        ).withOpacity(0.1),

        borderRadius:
            BorderRadius.circular(
                16),
      ),

      child: Icon(
        icon,

        color:
            const Color(
          0xFF0056B3,
        ),
      ),
    );
  }

  // ================= FEATURE TEXT =================
  Widget _buildFeatureText(
    String title,
    String subtitle,
  ) {

    return Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [

          Text(
            title,

            style:
                GoogleFonts.poppins(
              fontWeight:
                  FontWeight.w600,

              fontSize: 15,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,

            style:
                GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}