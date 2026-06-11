import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/halte_model.dart';
import '../models/wisata_model.dart';
import '../models/jadwal_model.dart';
import '../models/rute_populer_model.dart';
import '../models/notifikasi_model.dart';

class ApiService {
  static const String baseUrl = 'https://fence-confined-drift.ngrok-free.dev/api';
  static const String storageUrl = 'https://fence-confined-drift.ngrok-free.dev/storage';

  static const Map<String, String> _headers = {
    'ngrok-skip-browser-warning': 'true',
    'Content-Type': 'application/json',
  };

  static const Map<String, String> imageHeaders = {
    'ngrok-skip-browser-warning': 'true',
  };

  static Future<List<HalteModel>> fetchHalte() async {
    final response = await http
        .get(Uri.parse('$baseUrl/halte'), headers: _headers)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((e) => HalteModel.fromJson(e))
          .toList();
    }
    throw Exception('Gagal memuat data halte (${response.statusCode})');
  }

  static Future<List<WisataModel>> fetchWisataByHalte(int idHalte) async {
    final response = await http
        .get(Uri.parse('$baseUrl/wisata/halte/$idHalte'), headers: _headers)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((e) => WisataModel.fromJson(e))
          .toList();
    }
    throw Exception('Gagal memuat data wisata (${response.statusCode})');
  }

  static Future<List<JadwalModel>> fetchJadwalByHalte(int idHalte) async {
    final response = await http
        .get(Uri.parse('$baseUrl/jadwal/halte/$idHalte'), headers: _headers)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((e) => JadwalModel.fromJson(e))
          .toList();
    }
    throw Exception('Gagal memuat jadwal (${response.statusCode})');
  }

  static Future<void> postCariRute({
    required int idHalteAwal,
    required int idHalteTujuan,
    String? userId,
  }) async {
    try {
      await http
          .post(
            Uri.parse('$baseUrl/cari-rute'),
            headers: _headers,
            body: json.encode({
              'id_halte_awal': idHalteAwal,
              'id_halte_tujuan': idHalteTujuan,
              if (userId != null) 'user_id': userId,
            }),
          )
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      // Log gagal tidak perlu throw — tidak boleh blokir UI
    }
  }

  static Future<List<RutePopulerModel>> fetchRutePopuler() async {
    final response = await http
        .get(Uri.parse('$baseUrl/rute/populer'), headers: _headers)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((e) => RutePopulerModel.fromJson(e))
          .toList();
    }
    throw Exception('Gagal memuat rute populer (${response.statusCode})');
  }

  static Future<List<NotifikasiModel>> fetchNotifikasi() async {
    final response = await http
        .get(Uri.parse('$baseUrl/notifikasi'), headers: _headers)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((e) => NotifikasiModel.fromJson(e))
          .toList();
    }
    throw Exception('Gagal memuat notifikasi (${response.statusCode})');
  }
}
