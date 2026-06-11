import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../models/halte_model.dart';
import '../services/api_service.dart';
import 'peta_rute_view.dart';

class HalteView extends StatefulWidget {
  const HalteView({super.key});

  @override
  State<HalteView> createState() => _HalteViewState();
}

class _HalteViewState extends State<HalteView> {
  List<HalteModel> _halteList = [];
  LatLng? _userLocation;
  bool _isLoading = true;
  String? _error;

  final List<Color> _colors = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.wait([_loadHalte(), _loadUserLocation()]);
  }

  Future<void> _loadHalte() async {
    try {
      final list = await ApiService.fetchHalte();
      if (mounted) {
        setState(() {
          _halteList = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Gagal memuat data halte';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadUserLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(const Duration(seconds: 5));

      if (mounted) {
        setState(() {
          _userLocation = LatLng(pos.latitude, pos.longitude);
        });
      }
    } catch (_) {}
  }

  String _formatDistance(HalteModel halte) {
    if (_userLocation == null) return halte.alamat ?? "-";
    final meters = Geolocator.distanceBetween(
      _userLocation!.latitude,
      _userLocation!.longitude,
      halte.latitude,
      halte.longitude,
    );
    if (meters < 1000) return "${meters.round()} m";
    return "${(meters / 1000).toStringAsFixed(1)} km";
  }

  String _formatTime(HalteModel halte) {
    if (_userLocation == null) return "-";
    final meters = Geolocator.distanceBetween(
      _userLocation!.latitude,
      _userLocation!.longitude,
      halte.latitude,
      halte.longitude,
    );
    final minutes = (meters / 80).round();
    if (minutes < 1) return "< 1 Menit";
    return "$minutes Menit";
  }

  // Sort by distance dari user location, return index nearest
  int _nearestIndex() {
    if (_userLocation == null || _halteList.isEmpty) return 0;
    double minDist = double.infinity;
    int idx = 0;
    for (int i = 0; i < _halteList.length; i++) {
      final d = Geolocator.distanceBetween(
        _userLocation!.latitude,
        _userLocation!.longitude,
        _halteList[i].latitude,
        _halteList[i].longitude,
      );
      if (d < minDist) {
        minDist = d;
        idx = i;
      }
    }
    return idx;
  }

  @override
  Widget build(BuildContext context) {
    final nearestIdx = _nearestIndex();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 55, 20, 35),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0056B3), Color(0xFF2F80ED)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 12,
                    spreadRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.only(right: 14),
                          child: Icon(Icons.arrow_back,
                              color: Colors.white, size: 22),
                        ),
                      ),
                      Text(
                        "Halte Terdekat",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.directions_bus_rounded,
                          color: Colors.white, size: 40),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      "Temukan Halte Terdekat",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Cari halte bus terdekat\nlangsung dari lokasimu.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ================= HALTE LIST =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : _error != null
                      ? Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              const Icon(Icons.wifi_off,
                                  size: 48, color: Colors.grey),
                              const SizedBox(height: 16),
                              Text(
                                _error!,
                                style: GoogleFonts.poppins(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isLoading = true;
                                    _error = null;
                                  });
                                  _init();
                                },
                                child: const Text("Coba Lagi"),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            ...List.generate(_halteList.length, (i) {
                              final halte = _halteList[i];
                              final color = _colors[i % _colors.length];
                              final isNearest = (i == nearestIdx);
                              return _halteCard(
                                context,
                                halte,
                                _formatDistance(halte),
                                _formatTime(halte),
                                color,
                                isNearest: isNearest,
                              );
                            }),
                            const SizedBox(height: 20),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _halteCard(
    BuildContext context,
    HalteModel halte,
    String distance,
    String time,
    Color color, {
    bool isNearest = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PetaRuteView(
              startLocation: null,
              destinationLocation: halte.latLng,
              startName: "Lokasi Saya",
              destinationName: halte.namaHalte,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: isNearest
                ? Colors.green.withOpacity(0.25)
                : Colors.transparent,
            width: 1.3,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.directions_bus_filled,
                  color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          halte.namaHalte,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (isNearest)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Terdekat",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _infoChip(Icons.location_on, distance, Colors.grey),
                      const SizedBox(width: 10),
                      if (_userLocation != null)
                        _infoChip(Icons.access_time, time, Colors.blue),
                    ],
                  ),
                  if (halte.alamat != null && halte.alamat!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      halte.alamat!,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward_ios,
                  size: 15, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(color: color, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
