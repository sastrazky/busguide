import 'dart:convert';

class JadwalModel {
  final int idJadwal;
  final List<int> halteIds;
  final String waktuKeberangkatan;
  final String? waktuTiba;
  final String? status;
  final List<String> hariOperasi;
  final String? keterangan;

  JadwalModel({
    required this.idJadwal,
    required this.halteIds,
    required this.waktuKeberangkatan,
    this.waktuTiba,
    this.status,
    required this.hariOperasi,
    this.keterangan,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    List<String> hari = [];
    final rawHari = json['hari_operasi'];
    if (rawHari is List) {
      hari = List<String>.from(rawHari);
    } else if (rawHari is String && rawHari.isNotEmpty) {
      try {
        hari = List<String>.from(jsonDecode(rawHari));
      } catch (_) {
        hari = [rawHari];
      }
    }

    List<int> halteIds = [];
    final rawHalte = json['halte_ids'];
    if (rawHalte is List) {
      halteIds = rawHalte.map((e) => int.tryParse(e.toString()) ?? 0).toList();
    } else if (rawHalte is String && rawHalte.isNotEmpty) {
      try {
        halteIds = List<int>.from(
            (jsonDecode(rawHalte) as List)
                .map((e) => int.tryParse(e.toString()) ?? 0));
      } catch (_) {}
    }

    return JadwalModel(
      idJadwal: int.tryParse(json['id_jadwal'].toString()) ?? 0,
      halteIds: halteIds,
      waktuKeberangkatan: json['waktu_keberangkatan'] ?? '',
      waktuTiba: json['waktu_tiba'],
      status: json['status'],
      hariOperasi: hari,
      keterangan: json['keterangan'],
    );
  }
}
