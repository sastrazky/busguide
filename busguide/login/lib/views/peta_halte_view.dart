import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../models/halte_model.dart';
import '../models/jadwal_model.dart';
import '../models/wisata_model.dart';
import '../services/api_service.dart';
import 'peta_rute_view.dart';

class PetaHalteView extends StatefulWidget {
  const PetaHalteView({super.key});

  @override
  State<PetaHalteView> createState() => _PetaHalteViewState();
}

class _PetaHalteViewState extends State<PetaHalteView>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  List<HalteModel> _halteList = [];
  HalteModel? _selectedHalte;
  LatLng? _userLocation;
  bool _isLoading = true;
  bool _isGpsTracking = false;

  StreamSubscription<Position>? _positionStream;
  AnimationController? _animCtrl;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _animCtrl?.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final results = await Future.wait([
      ApiService.fetchHalte(),
      _getUserLocation(),
    ]);
    if (!mounted) return;
    setState(() {
      _halteList = results[0] as List<HalteModel>;
      _userLocation = results[1] as LatLng?;
      _isLoading = false;
    });

    if (_userLocation != null) {
      try {
        _mapController.move(_userLocation!, 14);
      } catch (_) {}
    } else if (_halteList.isNotEmpty) {
      try {
        _mapController.move(_halteList.first.latLng, 13);
      } catch (_) {}
    }
  }

  Future<LatLng?> _getUserLocation() async {
    try {
      final perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) return null;
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(const Duration(seconds: 5));
      return LatLng(pos.latitude, pos.longitude);
    } catch (_) {
      return null;
    }
  }

  void _toggleGps() async {
    if (_isGpsTracking) {
      _positionStream?.cancel();
      setState(() => _isGpsTracking = false);
      return;
    }

    final perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Izin lokasi diperlukan",
              style: GoogleFonts.poppins()),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isGpsTracking = true);
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((pos) {
      if (!mounted) return;
      final loc = LatLng(pos.latitude, pos.longitude);
      setState(() => _userLocation = loc);
      try {
        _mapController.move(loc, _mapController.camera.zoom);
      } catch (_) {}
    });

    final loc = await _getUserLocation();
    if (loc != null && mounted) {
      setState(() => _userLocation = loc);
      _animatedMove(loc, 16);
    }
  }

  void _animatedMove(LatLng dest, double zoom) {
    _animCtrl?.dispose();
    final cam = _mapController.camera;
    final latT = Tween<double>(begin: cam.center.latitude, end: dest.latitude);
    final lngT = Tween<double>(begin: cam.center.longitude, end: dest.longitude);
    final zoomT = Tween<double>(begin: cam.zoom, end: zoom);

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    final anim =
        CurvedAnimation(parent: _animCtrl!, curve: Curves.fastOutSlowIn);

    _animCtrl!.addListener(() {
      try {
        _mapController.move(
          LatLng(latT.evaluate(anim), lngT.evaluate(anim)),
          zoomT.evaluate(anim),
        );
      } catch (_) {}
    });
    _animCtrl!.forward();
  }

  int _nearestIndex() {
    if (_userLocation == null || _halteList.isEmpty) return 0;
    double min = double.infinity;
    int idx = 0;
    for (int i = 0; i < _halteList.length; i++) {
      final d = Geolocator.distanceBetween(
        _userLocation!.latitude, _userLocation!.longitude,
        _halteList[i].latitude, _halteList[i].longitude,
      );
      if (d < min) { min = d; idx = i; }
    }
    return idx;
  }

  void _onHalteTapped(HalteModel halte) {
    setState(() => _selectedHalte = halte);
    _animatedMove(halte.latLng, 15.5);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _HalteDetailSheet(halte: halte),
    ).whenComplete(() {
      if (mounted) setState(() => _selectedHalte = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final nearestIdx = _nearestIndex();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Peta Halte",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // ================= MAP =================
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _userLocation ??
                        (_halteList.isNotEmpty
                            ? _halteList.first.latLng
                            : const LatLng(-7.943100, 112.618900)),
                    initialZoom: 13.5,
                    onPositionChanged: (_, hasGesture) {
                      if (hasGesture && _isGpsTracking) {
                        setState(() => _isGpsTracking = false);
                        _positionStream?.cancel();
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.busguide.app',
                      maxZoom: 20,
                      retinaMode: true,
                      tileProvider: NetworkTileProvider(),
                    ),
                    MarkerLayer(
                      markers: [
                        // Halte markers
                        ..._halteList.asMap().entries.map((entry) {
                          final i = entry.key;
                          final halte = entry.value;
                          final isSelected =
                              _selectedHalte?.idHalte == halte.idHalte;
                          final isNearest = i == nearestIdx;
                          return Marker(
                            point: halte.latLng,
                            width: isSelected ? 100 : 80,
                            height: isSelected ? 80 : 65,
                            child: GestureDetector(
                              onTap: () => _onHalteTapped(halte),
                              child: _halteMarker(
                                halte.namaHalte,
                                isSelected: isSelected,
                                isNearest: isNearest,
                              ),
                            ),
                          );
                        }),
                        // User location
                        if (_userLocation != null)
                          Marker(
                            point: _userLocation!,
                            width: 40,
                            height: 40,
                            child: _userDot(),
                          ),
                      ],
                    ),
                  ],
                ),

                // ================= APPBAR GRADIENT =================
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: Container(
                    height: 160,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xCC000000), Colors.transparent],
                      ),
                    ),
                  ),
                ),

                // ================= HALTE COUNT CHIP =================
                Positioned(
                  top: MediaQuery.of(context).padding.top + 60,
                  left: 18,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.directions_bus,
                            size: 16, color: Color(0xFF0056B3)),
                        const SizedBox(width: 6),
                        Text(
                          "${_halteList.length} Halte",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: const Color(0xFF0056B3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ================= GPS BUTTON =================
                Positioned(
                  right: 18,
                  bottom: 40,
                  child: Column(
                    children: [
                      _fabButton(
                        icon: _isGpsTracking
                            ? Icons.gps_fixed
                            : Icons.gps_not_fixed,
                        isActive: _isGpsTracking,
                        onTap: _toggleGps,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _halteMarker(String name,
      {bool isSelected = false, bool isNearest = false}) {
    final color = isSelected
        ? const Color(0xFFFF6B35)
        : isNearest
            ? Colors.green
            : const Color(0xFF0056B3);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(isSelected ? 12 : 10),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: isSelected ? 18 : 10,
                spreadRadius: isSelected ? 2 : 0,
              ),
            ],
          ),
          child: Icon(
            Icons.directions_bus_filled,
            color: Colors.white,
            size: isSelected ? 22 : 18,
          ),
        ),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
              ),
            ],
          ),
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _userDot() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF4285F4).withOpacity(0.2),
      ),
      child: Center(
        child: Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF4285F4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fabButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFF0056B3) : Colors.grey[600],
        ),
      ),
    );
  }
}

// ============================================================
// HALTE DETAIL BOTTOM SHEET
// ============================================================

class _HalteDetailSheet extends StatefulWidget {
  final HalteModel halte;

  const _HalteDetailSheet({required this.halte});

  @override
  State<_HalteDetailSheet> createState() => _HalteDetailSheetState();
}

class _HalteDetailSheetState extends State<_HalteDetailSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  List<WisataModel> _wisataList = [];
  List<JadwalModel> _jadwalList = [];
  bool _loadingWisata = true;
  bool _loadingJadwal = true;
  String? _errorWisata;
  String? _errorJadwal;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadDetail();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    await Future.wait([
      ApiService.fetchWisataByHalte(widget.halte.idHalte).then((v) {
        if (mounted) setState(() { _wisataList = v; _loadingWisata = false; });
      }).catchError((e) {
        if (mounted) setState(() { _errorWisata = 'Gagal memuat wisata'; _loadingWisata = false; });
      }),
      ApiService.fetchJadwalByHalte(widget.halte.idHalte).then((v) {
        if (mounted) setState(() { _jadwalList = v; _loadingJadwal = false; });
      }).catchError((e) {
        if (mounted) setState(() { _errorJadwal = 'Gagal memuat jadwal'; _loadingJadwal = false; });
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 48,
            height: 5,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0056B3), Color(0xFF2F80ED)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.directions_bus_filled,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.halte.namaHalte,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      if (widget.halte.alamat != null)
                        Text(
                          widget.halte.alamat!,
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // TabBar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFF0056B3),
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
              tabs: const [
                Tab(text: "Info"),
                Tab(text: "Jadwal"),
                Tab(text: "Wisata"),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInfoTab(),
                _buildJadwalTab(),
                _buildWisataTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TAB INFO
  // ============================================================
  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(Icons.location_on, "Koordinat",
              "${widget.halte.latitude.toStringAsFixed(6)}, ${widget.halte.longitude.toStringAsFixed(6)}"),
          if (widget.halte.alamat != null)
            _infoRow(Icons.home, "Alamat", widget.halte.alamat!),
          if (widget.halte.deskripsi != null)
            _infoRow(Icons.info_outline, "Deskripsi", widget.halte.deskripsi!),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0056B3).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF0056B3)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: Colors.grey[500])),
                const SizedBox(height: 2),
                Text(value,
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TAB JADWAL
  // ============================================================
  Widget _buildJadwalTab() {
    if (_loadingJadwal) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorJadwal != null) {
      return _emptyState(Icons.schedule, _errorJadwal!);
    }
    if (_jadwalList.isEmpty) {
      return _emptyState(Icons.schedule, "Belum ada jadwal tersedia");
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      itemCount: _jadwalList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _jadwalCard(_jadwalList[i]),
    );
  }

  Widget _jadwalCard(JadwalModel j) {
    final statusColor = j.status == 'aktif' ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule, size: 16, color: Color(0xFF0056B3)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Jadwal #${j.idJadwal}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              if (j.status != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    j.status!,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _timeChip(Icons.departure_board, j.waktuKeberangkatan, Colors.green),
              if (j.waktuTiba != null) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
                ),
                _timeChip(Icons.flag, j.waktuTiba!, Colors.red),
              ],
            ],
          ),
          if (j.hariOperasi.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: j.hariOperasi.map((h) => _hariChip(h)).toList(),
            ),
          ],
          if (j.keterangan != null && j.keterangan!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              j.keterangan!,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _timeChip(IconData icon, String time, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            time,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _hariChip(String hari) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF0056B3).withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        hari,
        style: GoogleFonts.poppins(
          fontSize: 10,
          color: const Color(0xFF0056B3),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ============================================================
  // TAB WISATA
  // ============================================================
  Widget _buildWisataTab() {
    if (_loadingWisata) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorWisata != null) {
      return _emptyState(Icons.landscape, _errorWisata!);
    }
    if (_wisataList.isEmpty) {
      return _emptyState(Icons.landscape, "Belum ada wisata di halte ini");
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      itemCount: _wisataList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, i) => _wisataCard(_wisataList[i]),
    );
  }

  Widget _wisataCard(WisataModel w) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (w.gambarUrl != null)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                w.gambarUrl!,
                headers: ApiService.imageHeaders,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _imagePlaceholder(),
              ),
            )
          else
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: _imagePlaceholder(),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  w.namaWisata,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                if (w.lokasi != null && w.lokasi!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 13, color: Color(0xFF0056B3)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          w.lokasi!,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFF0056B3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (w.deskripsi != null && w.deskripsi!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    w.deskripsi!,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 100,
      color: const Color(0xFFF0F4FF),
      child: const Center(
        child: Icon(Icons.landscape, size: 40, color: Color(0xFF0056B3)),
      ),
    );
  }

  Widget _emptyState(IconData icon, String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(msg,
              style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 13)),
        ],
      ),
    );
  }
}
