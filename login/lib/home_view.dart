import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cari_rute_view.dart';
import 'peta_rute_view.dart';
import 'halte_view.dart';
import 'profil_view.dart';

class HomeView extends StatelessWidget {
  final String name;

  const HomeView({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ================= HEADER =================
              SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    _headerImage(),
                    _gradientTop(),
                    _gradientBottom(),
                    _headerContent(context),
                  ],
                ),
              ),

              // ================= CONTENT =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader("Rute Populer"),
                    const SizedBox(height: 10),

                    _buildCard(
                      "R05",
                      "Terminal A → Terminal B",
                      "25 menit",
                    ),
                    _buildCard(
                      "R12",
                      "Terminal B → Terminal C",
                      "30 menit",
                    ),
                    _buildCard(
                      "R20",
                      "Terminal C → Terminal A",
                      "35 menit",
                    ),

                    const SizedBox(height: 20),

                    _sectionHeader("Informasi Terkini"),
                    const SizedBox(height: 10),

                    _infoCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF0056B3),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProfileView(name: name),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // ================= HEADER PART =================
  Widget _headerImage() {
    return Container(
      height: 260,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bus_header.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _gradientTop() {
    return Container(
      height: 260,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xCC1565C0),
            Color(0x991E88E5),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  Widget _gradientBottom() {
    return Container(
      height: 260,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Color(0xFFF5F7F9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.65, 1.0],
        ),
      ),
    );
  }

  Widget _headerContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== TOP =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Selamat Datang di",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              _BellButton(),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            "Bus Guide",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Temukan rute bus terbaik\nmenuju tujuanmu",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 25),

          // ===== SEARCH =====
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(30),
            ),
            child: TextField(
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                icon: const Icon(Icons.search),
                hintText: "Cari rute atau halte...",
                hintStyle: GoogleFonts.poppins(),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 25),

          // ===== MENU =====
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: const [
                _MenuItemBlue(Icons.route, "Cari Rute"),
                _MenuItemBlue(Icons.map, "Lihat Peta"),
                _MenuItemBlue(Icons.location_on, "Halte"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION =================
  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "Lihat Semua >",
            style: GoogleFonts.poppins(),
          ),
        ),
      ],
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Rute R05 mengalami perubahan jalur\nMulai 1 Juni 2026",
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  // ================= CARD =================
  Widget _buildCard(
      String code, String title, String time) {
    Color color = code == "R05"
        ? Colors.blue
        : code == "R12"
            ? Colors.green
            : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Text(
              code,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 5),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Icon(Icons.directions_bus, color: color),
        ],
      ),
    );
  }
}

// ================= MENU =================
class _MenuItemBlue extends StatefulWidget {
  final IconData icon;
  final String label;

  const _MenuItemBlue(this.icon, this.label);

  @override
  State<_MenuItemBlue> createState() =>
      _MenuItemBlueState();
}

class _MenuItemBlueState
    extends State<_MenuItemBlue> {
  bool _pressed = false;

  void _handleTap(BuildContext context) {
    if (widget.label == "Cari Rute") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CariRuteView(),
        ),
      );
    }

    if (widget.label == "Lihat Peta") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PetaRuteView(),
        ),
      );
    }

    if (widget.label == "Halte") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const HalteView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) =>
          setState(() => _pressed = true),
      onTapUp: (_) =>
          setState(() => _pressed = false),
      onTapCancel: () =>
          setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.9 : 1,
        duration:
            const Duration(milliseconds: 120),
        child: InkWell(
          borderRadius:
              BorderRadius.circular(50),
          onTap: () => _handleTap(context),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0056B3)
                      .withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: const Color(0xFF0056B3),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.label,
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= BELL =================
class _BellButton extends StatefulWidget {
  const _BellButton();

  @override
  State<_BellButton> createState() =>
      _BellButtonState();
}

class _BellButtonState extends State<_BellButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) =>
          setState(() => _pressed = true),
      onTapUp: (_) =>
          setState(() => _pressed = false),
      onTapCancel: () =>
          setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.9 : 1,
        duration:
            const Duration(milliseconds: 120),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            borderRadius:
                BorderRadius.circular(50),
            splashColor: Colors.white24,
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white
                      .withOpacity(0.7),
                  width: 0.6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.15),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}