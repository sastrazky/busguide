import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cari_rute_view.dart';
import 'peta_rute_view.dart';
import 'halte_view.dart';
import 'profil_view.dart';
import 'notifikasi_view.dart';

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
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const SizedBox(height: 10),

                    // ================= TITLE =================
                    Text(
                      "Rute Populer",

                      style: GoogleFonts.poppins(
                        fontWeight:
                            FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _buildCard(
                      context,
                      "R05",
                      "Terminal A → Terminal B",
                      "25 menit",
                    ),

                    _buildCard(
                      context,
                      "R12",
                      "Terminal B → Terminal C",
                      "30 menit",
                    ),

                    _buildCard(
                      context,
                      "R20",
                      "Terminal C → Terminal A",
                      "35 menit",
                    ),

                    _buildCard(
                      context,
                      "R08",
                      "Terminal D → Jatimpark 1",
                      "20 menit",
                    ),

                    _buildCard(
                      context,
                      "R15",
                      "Jatimpark 2 → Terminal A",
                      "40 menit",
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: 0,

        selectedItemColor:
            const Color(0xFF0056B3),

        unselectedItemColor:
            Colors.grey,

        onTap: (index) {

          if (index == 1) {

            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (context) =>
                    ProfileView(
                  name: name,
                ),
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
      height: 230,

      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/bus_header.jpeg",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _gradientTop() {

    return Container(
      height: 230,

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
      height: 230,

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

  Widget _headerContent(
      BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // ===== TOP =====
          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

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
              fontSize: 30,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Temukan rute bus terbaik\nmenuju tujuanmu",

            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 30),

          // ===== MENU =====
          Container(
            padding:
                const EdgeInsets.symmetric(
              vertical: 18,
            ),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                24,
              ),

              boxShadow: [

                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.08),

                  blurRadius: 15,
                  offset:
                      const Offset(0, 8),
                ),
              ],
            ),

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceAround,

              children: const [

                _MenuItemBlue(
                  Icons.route,
                  "Cari Rute",
                ),

                _MenuItemBlue(
                  Icons.map,
                  "Lihat Peta",
                ),

                _MenuItemBlue(
                  Icons.location_on,
                  "Halte",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= CARD =================
  Widget _buildCard(
    BuildContext context,
    String code,
    String title,
    String time,
  ) {

    Color color = code == "R05"
        ? Colors.blue
        : code == "R12"
            ? Colors.green
            : code == "R20"
                ? Colors.orange
                : code == "R08"
                    ? Colors.purple
                    : Colors.red;

    return GestureDetector(

      // ===== DETAIL POPUP =====
      onTap: () {

        showModalBottomSheet(
          context: context,

          backgroundColor:
              Colors.transparent,

          isScrollControlled: true,

          builder: (_) {

            return Container(
              padding:
                  const EdgeInsets.all(24),

              decoration:
                  const BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.vertical(
                  top:
                      Radius.circular(30),
                ),
              ),

              child: Column(
                mainAxisSize:
                    MainAxisSize.min,

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Center(
                    child: Container(
                      width: 60,
                      height: 5,

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.grey[300],

                        borderRadius:
                            BorderRadius
                                .circular(
                          10,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),

                        decoration:
                            BoxDecoration(
                          gradient:
                              LinearGradient(
                            colors: [
                              color,
                              color
                                  .withOpacity(
                                      0.7),
                            ],
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                        ),

                        child: Text(
                          code,

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

                      const SizedBox(width: 14),

                      Expanded(
                        child: Text(
                          title,

                          style:
                              GoogleFonts
                                  .poppins(
                            fontSize: 18,

                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _detailItem(
                    Icons.access_time,
                    "Estimasi Waktu",
                    time,
                  ),

                  _detailItem(
                    Icons.location_on,
                    "Halte Awal",
                    title.split("→")[0],
                  ),

                  _detailItem(
                    Icons.flag,
                    "Halte Tujuan",
                    title.split("→")[1],
                  ),

                  _detailItem(
                    Icons.directions_bus,
                    "Status",
                    "Bus tersedia",
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },

      child: Container(
        margin:
            const EdgeInsets.only(
          bottom: 14,
        ),

        padding:
            const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            20,
          ),

          boxShadow: [

            BoxShadow(
              color: Colors.black
                  .withOpacity(0.05),

              blurRadius: 12,
            ),
          ],
        ),

        child: Row(
          children: [

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),

              decoration: BoxDecoration(
                gradient:
                    LinearGradient(
                  colors: [
                    color,
                    color.withOpacity(0.7),
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),

              child: Text(
                code,

                style:
                    GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
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
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    time,

                    style:
                        GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  // ================= DETAIL ITEM =================
  Widget _detailItem(
    IconData icon,
    String title,
    String value,
  ) {

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 18,
      ),

      child: Row(
        children: [

          Container(
            padding:
                const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color:
                  Colors.blue.withOpacity(
                0.1,
              ),

              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),

            child: Icon(
              icon,
              color:
                  const Color(0xFF0056B3),
              size: 20,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Text(
                  title,

                  style:
                      GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value.trim(),

                  style:
                      GoogleFonts.poppins(
                    fontWeight:
                        FontWeight.w600,

                    fontSize: 14,
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

// ================= MENU =================
class _MenuItemBlue
    extends StatefulWidget {

  final IconData icon;
  final String label;

  const _MenuItemBlue(
    this.icon,
    this.label,
  );

  @override
  State<_MenuItemBlue>
      createState() =>
          _MenuItemBlueState();
}

class _MenuItemBlueState
    extends State<_MenuItemBlue> {

  bool _pressed = false;

  void _handleTap(
      BuildContext context) {

    if (widget.label ==
        "Cari Rute") {

      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (_) =>
              const CariRuteView(),
        ),
      );
    }

    if (widget.label ==
        "Lihat Peta") {

      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (_) =>
              const PetaRuteView(),
        ),
      );
    }

    if (widget.label ==
        "Halte") {

      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (_) =>
              const HalteView(),
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
        scale:
            _pressed ? 0.9 : 1,

        duration:
            const Duration(
          milliseconds: 120,
        ),

        child: InkWell(
          borderRadius:
              BorderRadius.circular(50),

          onTap: () =>
              _handleTap(context),

          child: Column(
            children: [

              Container(
                padding:
                    const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(
                    colors: [
                      Color(0xFF2F80ED),
                      Color(0xFF56CCF2),
                    ],
                  ),

                  shape: BoxShape.circle,
                ),

                child: Icon(
                  widget.icon,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                widget.label,

                style:
                    GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w500,
                ),
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

class _BellButtonState
    extends State<_BellButton> {

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
        scale:
            _pressed ? 0.9 : 1,

        duration:
            const Duration(
          milliseconds: 120,
        ),

        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),

          child: InkWell(
            borderRadius:
                BorderRadius.circular(50),

            splashColor:
                Colors.white24,

            onTap: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                      const NotifikasiView(),
                ),
              );
            },

            child: Container(
              padding:
                  const EdgeInsets.all(10),

              decoration: BoxDecoration(
                color:
                    Colors.white
                        .withOpacity(0.2),

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