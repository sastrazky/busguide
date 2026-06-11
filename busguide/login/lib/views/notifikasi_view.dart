import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/notifikasi_model.dart';
import '../services/api_service.dart';

class NotifikasiView extends StatefulWidget {
  const NotifikasiView({super.key});

  @override
  State<NotifikasiView> createState() => _NotifikasiViewState();
}

class _NotifikasiViewState extends State<NotifikasiView> {
  List<NotifikasiModel> _notifikasi = [];
  bool _isLoading = true;
  String? _error;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    // Auto-refresh tiap 30 detik
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _fetchData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final data = await ApiService.fetchNotifikasi();
      if (mounted) {
        setState(() {
          _notifikasi = data;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Gagal memuat notifikasi';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0056B3),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Notifikasi',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchData();
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              _error!,
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() => _isLoading = true);
                _fetchData();
              },
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_notifikasi.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              'Belum ada notifikasi',
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifikasi.length,
        itemBuilder: (context, index) =>
            _notifCard(_notifikasi[index]),
      ),
    );
  }

  Widget _notifCard(NotifikasiModel notif) {
    final config = _getConfig(notif.tipe, notif.aksi);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcon(config['icon'] as IconData, config['color'] as Color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif.judul,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  notif.pesan,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[700],
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _formatWaktu(notif.createdAt),
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

  Widget _buildIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color),
    );
  }

  Map<String, dynamic> _getConfig(String tipe, String aksi) {
    Color color;
    IconData icon;

    // Warna berdasarkan tipe
    switch (tipe) {
      case 'halte':
        color = Colors.blue;
        icon = Icons.location_on;
        break;
      case 'jadwal':
        color = Colors.orange;
        icon = Icons.access_time;
        break;
      case 'wisata':
        color = Colors.green;
        icon = Icons.landscape;
        break;
      default:
        color = Colors.grey;
        icon = Icons.notifications;
    }

    // Override icon berdasarkan aksi
    if (aksi == 'hapus') {
      icon = tipe == 'halte'
          ? Icons.location_off
          : tipe == 'jadwal'
              ? Icons.timer_off
              : Icons.hide_image;
      color = Colors.red;
    } else if (aksi == 'ubah') {
      icon = Icons.edit_note;
    }

    return {'icon': icon, 'color': color};
  }

  String _formatWaktu(DateTime waktu) {
    final sekarang = DateTime.now();
    final selisih = sekarang.difference(waktu);

    if (selisih.inMinutes < 1) return 'Baru saja';
    if (selisih.inMinutes < 60) return '${selisih.inMinutes} menit lalu';
    if (selisih.inHours < 24) return '${selisih.inHours} jam lalu';
    if (selisih.inDays == 1) return 'Kemarin';
    if (selisih.inDays < 7) return '${selisih.inDays} hari lalu';

    return '${waktu.day}/${waktu.month}/${waktu.year}';
  }
}
