import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/cari_rute_controller.dart';
import '../models/halte_model.dart';
import '../models/wisata_model.dart';
import '../services/api_service.dart';

class CariRuteView extends StatefulWidget {
  final int? initialIdHalteAwal;
  final int? initialIdHalteTujuan;

  const CariRuteView({
    super.key,
    this.initialIdHalteAwal,
    this.initialIdHalteTujuan,
  });

  @override
  State<CariRuteView> createState() => _CariRuteViewState();
}

class _CariRuteViewState extends State<CariRuteView> {
  final MapController _mapController = MapController();
  late final CariRuteController _controller;
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _controller = CariRuteController(
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );
    _controller.loadHalte(
      initialIdHalteAwal: widget.initialIdHalteAwal,
      initialIdHalteTujuan: widget.initialIdHalteTujuan,
    );
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(const Duration(seconds: 5));
      if (mounted) setState(() => _userLocation = LatLng(pos.latitude, pos.longitude));
    } catch (_) {}
  }

  String _estimasiWaktu() {
    final awal = _controller.selectedHalteAwal;
    final tujuan = _controller.selectedHalteTujuan;
    if (awal == null || tujuan == null) return "-";
    final meters = Geolocator.distanceBetween(
      awal.latitude,
      awal.longitude,
      tujuan.latitude,
      tujuan.longitude,
    );
    final minutes = (meters / 80).round();
    if (minutes < 1) return "< 1 Menit";
    return "$minutes Menit";
  }

  @override
  Widget build(BuildContext context) {
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
                        "Cari Rute",
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
                      child: const Icon(Icons.route,
                          color: Colors.white, size: 40),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      "Cari Rute",
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
                      "Pilih halte awal dan halte tujuan.\nWisata otomatis muncul dari halte tujuan.",
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

            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildForm(),
                    const SizedBox(height: 25),
                    _buildPreviewMap(),
                    const SizedBox(height: 25),
                    if (_controller.showResult) _buildResult(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          _inputCard(
            title: "Halte Awal",
            value: _controller.selectedHalteAwal?.namaHalte ?? "Pilih Halte",
            icon: Icons.my_location,
            onTap: () {
              _showPilihan("Pilih Halte Awal", (halte) {
                setState(() {
                  _controller.selectedHalteAwal = halte;
                  _controller.updatePreviewRoute(
                    onMoveMap: (pos) => _mapController.move(pos, 13.5),
                  );
                });
              });
            },
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () {
              setState(() {
                final temp = _controller.selectedHalteAwal;
                _controller.selectedHalteAwal = _controller.selectedHalteTujuan;
                _controller.selectedHalteTujuan = temp;
                _controller.updatePreviewRoute(
                  onMoveMap: (pos) => _mapController.move(pos, 13.5),
                );
              });
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0052D4), Color(0xFF4364F7)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.swap_vert, color: Colors.white),
            ),
          ),
          const SizedBox(height: 18),
          _inputCard(
            title: "Halte Tujuan",
            value: _controller.selectedHalteTujuan?.namaHalte ?? "Pilih Halte",
            icon: Icons.location_on,
            onTap: () {
              _showPilihan("Pilih Halte Tujuan", (halte) {
                setState(() {
                  _controller.selectedHalteTujuan = halte;
                  _controller.updatePreviewRoute(
                    onMoveMap: (pos) => _mapController.move(pos, 13.5),
                  );
                });
              });
            },
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _controller.isLoadingHalte
                  ? null
                  : () => _controller.generateWisata(),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFF0056B3),
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: Text(
                "CARI RUTE",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fade().moveY(begin: 20);
  }

  Widget _inputCard({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF0056B3)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  _controller.isLoadingHalte
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          value,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewMap() {
    return Container(
      height: 270,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _controller.previewRoute.isNotEmpty
                    ? _controller.previewRoute.first
                    : const LatLng(-7.943100, 112.618900),
                initialZoom: 13.5,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                  maxZoom: 20,
                  retinaMode: true,
                  tileProvider: NetworkTileProvider(),
                ),
                if (_controller.previewRoute.length >= 2)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _controller.previewRoute,
                        strokeWidth: 12,
                        color: Colors.blue.withOpacity(0.15),
                      ),
                      Polyline(
                        points: _controller.previewRoute,
                        strokeWidth: 6,
                        color: const Color(0xFF0056B3),
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    if (_controller.previewRoute.isNotEmpty)
                      Marker(
                        point: _controller.previewRoute.first,
                        width: 90,
                        height: 90,
                        child: _mapMarker(
                          title: _controller.selectedHalteAwal?.namaHalte ?? "",
                          color: Colors.green,
                          icon: Icons.directions_bus,
                        ),
                      ),
                    if (_controller.previewRoute.isNotEmpty)
                      Marker(
                        point: _controller.previewRoute.last,
                        width: 90,
                        height: 90,
                        child: _mapMarker(
                          title:
                              _controller.selectedHalteTujuan?.namaHalte ?? "",
                          color: Colors.red,
                          icon: Icons.place,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _previewInfo(
                          Icons.access_time,
                          "Estimasi Waktu: ${_estimasiWaktu()}",
                          color: const Color(0xFF0056B3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapMarker({
    required String title,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.4), blurRadius: 15),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.08), blurRadius: 10),
            ],
          ),
          child: Text(
            title,
            style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _previewInfo(IconData icon, String text, {Color color = const Color(0xFF0056B3)}) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Wisata Dekat ${_controller.selectedHalteTujuan?.namaHalte ?? ""}",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 18),
        if (_controller.isLoadingWisata)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_controller.wisataResult.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                "Tidak ada wisata ditemukan",
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
          )
        else
          ..._controller.wisataResult
              .map((e) => _wisataCard(e))
              .toList(),
      ],
    );
  }

  Widget _wisataCard(WisataModel data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.gambarUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              child: Image.network(
                data.gambarUrl!,
                headers: ApiService.imageHeaders,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 140,
                  color: const Color(0xFFF0F4FF),
                  child: const Center(
                    child: Icon(Icons.image_not_supported,
                        size: 48, color: Colors.grey),
                  ),
                ),
              ),
            )
          else
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              child: Container(
                height: 140,
                color: const Color(0xFFF0F4FF),
                child: const Center(
                  child: Icon(Icons.landscape, size: 48, color: Color(0xFF0056B3)),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.namaWisata,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                if (data.lokasi != null && data.lokasi!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _miniInfo(Icons.location_on, data.lokasi!),
                ],
                if (data.deskripsi != null && data.deskripsi!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    data.deskripsi!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
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
    ).animate().fade().moveY(begin: 30);
  }

  Widget _miniInfo(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0056B3).withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF0056B3)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPilihan(String title, Function(HalteModel) onSelect) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 5,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 15),
              if (_controller.isLoadingHalte)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _controller.halteList.length,
                    itemBuilder: (_, index) {
                      final halte = _controller.halteList[index];
                      return ListTile(
                        leading: const Icon(Icons.directions_bus),
                        title: Text(halte.namaHalte),
                        subtitle: halte.alamat != null
                            ? Text(
                                halte.alamat!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              )
                            : null,
                        onTap: () {
                          Navigator.pop(context);
                          onSelect(halte);
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
