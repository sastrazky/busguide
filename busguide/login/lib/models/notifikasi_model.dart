class NotifikasiModel {
  final int id;
  final String judul;
  final String pesan;
  final String tipe;
  final String aksi;
  final DateTime createdAt;

  NotifikasiModel({
    required this.id,
    required this.judul,
    required this.pesan,
    required this.tipe,
    required this.aksi,
    required this.createdAt,
  });

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
    return NotifikasiModel(
      id: json['id'],
      judul: json['judul'],
      pesan: json['pesan'],
      tipe: json['tipe'],
      aksi: json['aksi'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
