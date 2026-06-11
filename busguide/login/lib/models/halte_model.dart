import 'package:latlong2/latlong.dart';

class HalteModel {
  final int idHalte;
  final String namaHalte;
  final double latitude;
  final double longitude;
  final String? alamat;
  final String? deskripsi;

  HalteModel({
    required this.idHalte,
    required this.namaHalte,
    required this.latitude,
    required this.longitude,
    this.alamat,
    this.deskripsi,
  });

  LatLng get latLng => LatLng(latitude, longitude);

  factory HalteModel.fromJson(Map<String, dynamic> json) {
    return HalteModel(
      idHalte: int.tryParse(json['id_halte'].toString()) ?? 0,
      namaHalte: json['nama_halte'] ?? '',
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      alamat: json['alamat'],
      deskripsi: json['deskripsi'],
    );
  }
}
