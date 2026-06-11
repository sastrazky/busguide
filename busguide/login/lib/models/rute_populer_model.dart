class RutePopulerModel {
  final int idHalteAwal;
  final String namaHalteAwal;
  final int idHalteTujuan;
  final String namaHalteTujuan;
  final int totalPencarian;

  RutePopulerModel({
    required this.idHalteAwal,
    required this.namaHalteAwal,
    required this.idHalteTujuan,
    required this.namaHalteTujuan,
    required this.totalPencarian,
  });

  factory RutePopulerModel.fromJson(Map<String, dynamic> json) {
    return RutePopulerModel(
      idHalteAwal: json['id_halte_awal'] as int,
      namaHalteAwal: json['nama_halte_awal'] ?? '-',
      idHalteTujuan: json['id_halte_tujuan'] as int,
      namaHalteTujuan: json['nama_halte_tujuan'] ?? '-',
      totalPencarian: json['total_pencarian'] as int,
    );
  }
}
