import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cari_rute_view.dart';
import 'peta_rute_view.dart';
import 'peta_halte_view.dart';
import 'halte_view.dart';
import 'profil_view.dart';
import 'notifikasi_view.dart';
import '../models/rute_populer_model.dart';
import '../services/api_service.dart';

class HomeView extends StatefulWidget {
  final String name;

  const HomeView({
    super.key,
    required this.name,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<RutePopulerModel> _rutePopuler = [];
  bool _loadingRute = true;

  @override
  void initState() {
    super.initState();
    _checkGpsAndPermission();
    _loadRutePopuler();
  }

  Future<void> _loadRutePopuler() async {
    try {
      final data = await ApiService.fetchRutePopuler();
      if (mounted) setState(() => _rutePopuler = data);
    } catch (_) {
      // Biarkan kosong jika gagal
    } finally {
      if (mounted) setState(() => _loadingRute = false);
    }
  }

  Future<void> _checkGpsAndPermission() async {
  bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showGpsDisabledDialog();
    });
    return;
  }

  _checkLocationPermission();

  Geolocator.getServiceStatusStream().listen((status) {
    if (status == ServiceStatus.disabled && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "GPS dimatikan. Tracking realtime tidak tersedia.",
            style: GoogleFonts.poppins(),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  });
}

  Future<void> _checkLocationPermission() async {
    final prefs = await SharedPreferences.getInstance();
    final choice = prefs.getString('location_permission_choice');
    if (choice == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCustomPermissionDialog();
      });
    }
  }

  void _showCustomPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xFF0056B3),
                  size: 32,
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontSize: 15,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: "Izinkan "),
                      TextSpan(
                        text: "Bus Guide",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: " mengakses lokasi perangkat ini?"),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildMapIllustration(),
                const SizedBox(height: 24),
                const Divider(height: 1, color: Colors.black12),
                _buildDialogOption(
                  label: "Saat aplikasi digunakan",
                  onTap: () => _handlePermissionChoice("always"),
                ),
                const Divider(height: 1, color: Colors.black12),
                _buildDialogOption(
                  label: "Hanya kali ini",
                  onTap: () => _handlePermissionChoice("once"),
                ),
                const Divider(height: 1, color: Colors.black12),
                _buildDialogOption(
                  label: "Jangan izinkan",
                  onTap: () => _handlePermissionChoice("denied"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showGpsDisabledDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: const [
            Icon(
              Icons.location_off,
              color: Colors.red,
            ),
            SizedBox(width: 8),
            Text("GPS Nonaktif"),
          ],
        ),
        content: Text(
          "Tracking realtime tidak dapat digunakan karena GPS perangkat sedang nonaktif.\n\nSilakan aktifkan GPS terlebih dahulu.",
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
            },
            child: Text(
              "Aktifkan GPS",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}

  Widget _buildMapIllustration() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFE8F0FE),
        border: Border.all(
          color: const Color(0xFFADCCF7),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 1,
            color: const Color(0xFFADCCF7).withOpacity(0.5),
          ),
          Container(
            width: 1,
            color: const Color(0xFFADCCF7).withOpacity(0.5),
          ),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFADCCF7).withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFADCCF7).withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 30,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 35,
            right: 35,
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 65,
            right: 25,
            child: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Icon(
            Icons.location_on,
            color: Color(0xFF0056B3),
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildDialogOption({
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: const Color(0xFF0056B3),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handlePermissionChoice(String choice) async {
    Navigator.pop(context);
    final prefs = await SharedPreferences.getInstance();
    
    if (choice == "denied") {
      await prefs.setString('location_permission_choice', 'denied');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Izin lokasi ditolak. Anda tidak dapat menggunakan fitur pelacakan realtime.",
              style: GoogleFonts.poppins(),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }
    
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    if (permission == LocationPermission.always ||
    permission == LocationPermission.whileInUse) {

  bool gpsEnabled =
      await Geolocator.isLocationServiceEnabled();

  if (!gpsEnabled) {
    _showGpsDisabledDialog();
    return;
  }
  
      await prefs.setString('location_permission_choice', choice);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Izin lokasi diberikan. Pelacakan realtime aktif.",
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      await prefs.setString('location_permission_choice', 'denied');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Izin lokasi perangkat ditolak.",
              style: GoogleFonts.poppins(),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadRutePopuler,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(context),
                _buildContent(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(
    BuildContext context,
  ) {

    return SizedBox(
      width: double.infinity,

      child: Stack(
        children: [

          _headerImage(),

          _gradientTop(),

          _gradientBottom(),

          _headerContent(context),
        ],
      ),
    );
  }

  // ================= CONTENT =================
  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "Rute Populer",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 18),
          if (_loadingRute)
            const Center(child: CircularProgressIndicator())
          else if (_rutePopuler.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  "Belum ada rute populer",
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
              ),
            )
          else
            ..._rutePopuler.asMap().entries.map((entry) {
              final i = entry.key;
              final rute = entry.value;
              final colors = [
                Colors.blue,
                Colors.green,
                Colors.orange,
                Colors.purple,
                Colors.red,
              ];
              return _buildCard(
                context,
                '#${i + 1}',
                '${rute.namaHalteAwal} → ${rute.namaHalteTujuan}',
                '${rute.totalPencarian}x dicari',
                rute.idHalteAwal,
                rute.idHalteTujuan,
                colors[i % colors.length],
              );
            }),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // ================= BOTTOM NAV =================
  Widget _buildBottomNav(
    BuildContext context,
  ) {

    return BottomNavigationBar(
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
                name: widget.name,
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
    );
  }

  // ================= HEADER IMAGE =================
  Widget _headerImage() {

    return Container(
      height: 230,

      decoration:
          const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/bus_header.jpeg",
          ),

          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ================= GRADIENT TOP =================
  Widget _gradientTop() {

    return Container(
      height: 230,

      decoration:
          const BoxDecoration(
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

  // ================= GRADIENT BOTTOM =================
  Widget _gradientBottom() {

    return Container(
      height: 230,

      decoration:
          const BoxDecoration(
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

  // ================= HEADER CONTENT =================
  Widget _headerContent(
    BuildContext context,
  ) {

    return Padding(
      padding:
          const EdgeInsets.all(
        20,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // ================= TOP =================
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

            style:
                GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 30,

              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Temukan rute bus terbaik\nmenuju tujuanmu",

            style:
                GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 30),

          // ================= MENU =================
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
                      const Offset(
                    0,
                    8,
                  ),
                ),
              ],
            ),

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceAround,

              children: [

                _MenuItemBlue(
                  Icons.route,
                  "Cari Rute",
                  onReturn: _loadRutePopuler,
                ),

                const _MenuItemBlue(
                  Icons.map,
                  "Lihat Peta",
                ),

                const _MenuItemBlue(
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
    String subtitle,
    int idHalteAwal,
    int idHalteTujuan,
    Color color,
  ) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CariRuteView(
              initialIdHalteAwal: idHalteAwal,
              initialIdHalteTujuan: idHalteTujuan,
            ),
          ),
        );
        _loadRutePopuler();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                code,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
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
                const EdgeInsets.all(
                    10),

            decoration: BoxDecoration(
              color:
                  Colors.blue
                      .withOpacity(
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
                  const Color(
                0xFF0056B3,
              ),

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
  final VoidCallback? onReturn;

  const _MenuItemBlue(
    this.icon,
    this.label, {
    this.onReturn,
  });

  @override
  State<_MenuItemBlue>
      createState() =>
          _MenuItemBlueState();
}

class _MenuItemBlueState
    extends State<_MenuItemBlue> {

  bool _pressed = false;

Future<void> _handleTap(BuildContext context) async {
  if (widget.label == "Cari Rute") {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CariRuteView(),
      ),
    );
    widget.onReturn?.call();
    return;
  }

  if (widget.label == "Lihat Peta") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PetaHalteView(),
      ),
    );
    return;
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
          setState(
        () => _pressed = true,
      ),

      onTapUp: (_) =>
          setState(
        () => _pressed = false,
      ),

      onTapCancel: () =>
          setState(
        () => _pressed = false,
      ),

      child: AnimatedScale(
        scale:
            _pressed ? 0.9 : 1,

        duration:
            const Duration(
          milliseconds: 120,
        ),

        child: InkWell(
          borderRadius:
              BorderRadius.circular(
            50,
          ),

          onTap: () =>
              _handleTap(context),

          child: Column(
            children: [

              Container(
                padding:
                    const EdgeInsets.all(
                        14),

                decoration:
                    const BoxDecoration(
                  gradient:
                      LinearGradient(
                    colors: [
                      Color(0xFF2F80ED),
                      Color(0xFF56CCF2),
                    ],
                  ),

                  shape:
                      BoxShape.circle,
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
class _BellButton
    extends StatefulWidget {

  const _BellButton();

  @override
  State<_BellButton>
      createState() =>
          _BellButtonState();
}

class _BellButtonState
    extends State<_BellButton> {

  bool _pressed = false;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTapDown: (_) =>
          setState(
        () => _pressed = true,
      ),

      onTapUp: (_) =>
          setState(
        () => _pressed = false,
      ),

      onTapCancel: () =>
          setState(
        () => _pressed = false,
      ),

      child: AnimatedScale(
        scale:
            _pressed ? 0.9 : 1,

        duration:
            const Duration(
          milliseconds: 120,
        ),

        child: Material(
          color: Colors.transparent,

          shape:
              const CircleBorder(),

          child: InkWell(
            borderRadius:
                BorderRadius.circular(
              50,
            ),

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
                  const EdgeInsets.all(
                      10),

              decoration: BoxDecoration(
                color:
                    Colors.white
                        .withOpacity(0.2),

                shape:
                    BoxShape.circle,

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