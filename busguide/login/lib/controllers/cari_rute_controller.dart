import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '../models/halte_model.dart';
import '../models/wisata_model.dart';
import '../services/api_service.dart';

class CariRuteController {
  final VoidCallback onStateChanged;

  List<HalteModel> halteList = [];
  HalteModel? selectedHalteAwal;
  HalteModel? selectedHalteTujuan;

  bool isLoadingHalte = false;
  bool isLoadingWisata = false;
  bool showResult = false;

  List<WisataModel> wisataResult = [];
  List<LatLng> previewRoute = [];

  CariRuteController({required this.onStateChanged});

  void dispose() {}

  Future<void> loadHalte({int? initialIdHalteAwal, int? initialIdHalteTujuan}) async {
    isLoadingHalte = true;
    onStateChanged();
    try {
      halteList = await ApiService.fetchHalte();
      if (halteList.isNotEmpty) {
        selectedHalteAwal = halteList.firstWhere(
          (h) => h.idHalte == initialIdHalteAwal,
          orElse: () => halteList[0],
        );
        selectedHalteTujuan = halteList.firstWhere(
          (h) => h.idHalte == initialIdHalteTujuan,
          orElse: () => halteList.length >= 2 ? halteList[1] : halteList[0],
        );
        await updatePreviewRoute(shouldTriggerMove: false);
      }
    } catch (e) {
      debugPrint('Gagal load halte: $e');
    } finally {
      isLoadingHalte = false;
      onStateChanged();
    }
  }

  Future<void> updatePreviewRoute({
    bool shouldTriggerMove = true,
    void Function(LatLng)? onMoveMap,
  }) async {
    if (selectedHalteAwal == null || selectedHalteTujuan == null) return;

    final start = selectedHalteAwal!.latLng;
    final end = selectedHalteTujuan!.latLng;

    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
      '${start.longitude},${start.latitude};${end.longitude},${end.latitude}'
      '?overview=full&geometries=geojson',
    );

    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'BusGuideFlutterApp/1.0',
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 'Ok' &&
            data['routes'] != null &&
            (data['routes'] as List).isNotEmpty) {
          final coordinates =
              data['routes'][0]['geometry']['coordinates'] as List;
          previewRoute = coordinates
              .map((c) => LatLng(c[1] as double, c[0] as double))
              .toList();
          onStateChanged();
          if (shouldTriggerMove &&
              previewRoute.isNotEmpty &&
              onMoveMap != null) {
            onMoveMap(previewRoute.first);
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('OSRM CariRute Error: $e');
    }

    previewRoute = [start, end];
    onStateChanged();
    if (shouldTriggerMove && onMoveMap != null) {
      onMoveMap(start);
    }
  }

  Future<void> generateWisata() async {
    if (selectedHalteAwal == null || selectedHalteTujuan == null) return;
    showResult = true;
    isLoadingWisata = true;
    onStateChanged();

    // Kirim log pencarian ke backend (fire-and-forget)
    ApiService.postCariRute(
      idHalteAwal: selectedHalteAwal!.idHalte,
      idHalteTujuan: selectedHalteTujuan!.idHalte,
    );

    try {
      wisataResult =
          await ApiService.fetchWisataByHalte(selectedHalteTujuan!.idHalte);
    } catch (e) {
      debugPrint('Gagal load wisata: $e');
      wisataResult = [];
    } finally {
      isLoadingWisata = false;
      onStateChanged();
    }
  }
}
