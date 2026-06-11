import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

enum GpsMode {
  none,
  follow,
  compass,
}

class PetaRuteController {
  final VoidCallback onStateChanged;

  LatLng destinationLocation;
  LatLng? startLocation;
  String? startName;
  String? destinationName;

  List<LatLng> routePoints = [];

  String from = "";
  String to = "";
  String duration = "";
  String distance = "";

  bool isLoading = true;

  // ================= GPS STATES =================
  LatLng? currentLocation;
  StreamSubscription<Position>? positionStream;

  bool isGpsEnabled = false;
  bool isPermissionGranted = false;
  bool isCheckingLocation = true;
  GpsMode gpsMode = GpsMode.follow;
  double currentHeading = 0.0;

  bool get isTrackingUser => gpsMode != GpsMode.none;

  PetaRuteController({
    required this.onStateChanged,
    required this.destinationLocation,
    this.startLocation,
    this.startName,
    this.destinationName,
  }) {
    from = startName ?? "Lokasi Saya";
    to = destinationName ?? "Halte B";
  }

  void dispose() {
    positionStream?.cancel();
  }

  // ================= CHECK LOCATION STATUS =================
  Future<LatLng?> checkGpsAndInit() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isGpsEnabled = false;
      isCheckingLocation = false;
      onStateChanged();
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied || 
        permission == LocationPermission.deniedForever) {
      isGpsEnabled = true;
      isPermissionGranted = false;
      isCheckingLocation = false;
      currentLocation = const LatLng(-7.9424, 112.6220); // Fallback mock location: Soekarno Hatta
      onStateChanged();
      return currentLocation;
    }

    isGpsEnabled = true;
    isPermissionGranted = true;
    isCheckingLocation = false;
    onStateChanged();

    return await initLocationStream();
  }

  // ================= GET CLEAN USER LOCATION =================
  LatLng getCleanUserLocation(Position pos) {
    double distFromMalang = Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      -7.982908,
      112.630833,
    );
    if (distFromMalang > 50000) {
      return const LatLng(-7.982908, 112.630833);
    }
    return LatLng(pos.latitude, pos.longitude);
  }

  // ================= FALLBACK STREET-ALIGNED ROUTE =================
  List<LatLng> getFallbackRoute(LatLng start, LatLng end) {
    bool isNear(LatLng p1, LatLng p2) {
      return (p1.latitude - p2.latitude).abs() < 0.005 && 
             (p1.longitude - p2.longitude).abs() < 0.005;
    }

    final LatLng lowokwaru = const LatLng(-7.9424, 112.6220);
    final LatLng halteA = const LatLng(-7.943100, 112.618900);
    final LatLng halteB = const LatLng(-7.944900, 112.611400);
    final LatLng jp1 = const LatLng(-7.897292, 112.524953);
    final LatLng jp2 = const LatLng(-7.889392, 112.528892);

    if (isNear(start, lowokwaru) && isNear(end, halteA)) {
      return [
        start,
        const LatLng(-7.9424, 112.618900),
        halteA,
      ];
    }

    if (isNear(start, lowokwaru) && isNear(end, halteB)) {
      return [
        start,
        const LatLng(-7.9424, 112.615000),
        const LatLng(-7.944900, 112.615000),
        halteB,
      ];
    }

    if (isNear(start, lowokwaru) && isNear(end, jp1)) {
      return [
        start,
        const LatLng(-7.9424, 112.6150),
        const LatLng(-7.9520, 112.6150),
        const LatLng(-7.9300, 112.5900),
        const LatLng(-7.9100, 112.5600),
        jp1,
      ];
    }

    if (isNear(start, lowokwaru) && isNear(end, jp2)) {
      return [
        start,
        const LatLng(-7.9424, 112.6150),
        const LatLng(-7.9520, 112.6150),
        const LatLng(-7.9300, 112.5900),
        const LatLng(-7.9100, 112.5600),
        jp2,
      ];
    }

    if (isNear(start, halteA) && isNear(end, halteB)) {
      return [
        halteA,
        const LatLng(-7.943100, 112.615000),
        const LatLng(-7.944900, 112.615000),
        halteB,
      ];
    }

    if (isNear(start, halteA) && isNear(end, jp1)) {
      return [
        halteA,
        const LatLng(-7.9424, 112.6150),
        const LatLng(-7.9300, 112.5900),
        const LatLng(-7.9100, 112.5600),
        jp1,
      ];
    }

    if (isNear(start, halteA) && isNear(end, jp2)) {
      return [
        halteA,
        const LatLng(-7.9424, 112.6150),
        const LatLng(-7.9300, 112.5900),
        const LatLng(-7.9100, 112.5600),
        jp2,
      ];
    }

    // Proximity to Stasiun Malang (widget destination location fallback)
    if (isNear(end, const LatLng(-7.944900, 112.611400))) {
      return [
        start,
        const LatLng(-7.9424, 112.615000),
        const LatLng(-7.944900, 112.615000),
        const LatLng(-7.944900, 112.611400),
      ];
    }

    return [start, end];
  }

  // ================= FETCH OSRM ROUTE =================
  Future<void> fetchOSRMRoute(LatLng start, LatLng end) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
      '${start.longitude},${start.latitude};${end.longitude},${end.latitude}'
      '?overview=full'
      '&geometries=geojson'
      '&steps=true',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'BusGuideFlutterApp/1.0',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 'Ok' && data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry'];
          final coordinates = geometry['coordinates'] as List;

          final List<LatLng> points = coordinates.map((coord) {
            return LatLng(coord[1] as double, coord[0] as double);
          }).toList();

          final double routeDistance = (route['distance'] as num).toDouble(); // meters
          final double routeDuration = (route['duration'] as num).toDouble(); // seconds

          routePoints = points;
          distance = "${(routeDistance / 1000).toStringAsFixed(1)} Km";
          duration = "${(routeDuration / 60).round()} Menit";
          isLoading = false;
          onStateChanged();
          return;
        }
      }
    } catch (e) {
      debugPrint("OSRM API Error: $e");
    }

    // Fallback if API fails
    routePoints = getFallbackRoute(start, end);
    distance = "${(Geolocator.distanceBetween(start.latitude, start.longitude, end.latitude, end.longitude) / 1000).toStringAsFixed(1)} Km";
    duration = "${(Geolocator.distanceBetween(start.latitude, start.longitude, end.latitude, end.longitude) / 80).round()} Menit";
    isLoading = false;
    onStateChanged();
  }

  // ================= LOAD ROUTE =================
  Future<void> loadRoute() async {
    isLoading = true;
    onStateChanged();

    if (startLocation != null) {
      await fetchOSRMRoute(startLocation!, destinationLocation);
      return;
    }

    bool hasPermission = false;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      hasPermission = (permission == LocationPermission.always || permission == LocationPermission.whileInUse);
    } catch (_) {}

    if (hasPermission) {
      try {
        Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        final startLatLng = getCleanUserLocation(pos);
        currentLocation = startLatLng;
        onStateChanged();
        await fetchOSRMRoute(startLatLng, destinationLocation);
        return;
      } catch (_) {
        // Fallback to mock location if fails
        final mockLatLng = const LatLng(-7.9424, 112.6220); // Soekarno Hatta
        currentLocation = mockLatLng;
        onStateChanged();
        await fetchOSRMRoute(mockLatLng, destinationLocation);
        return;
      }
    }

    // Fallback static route Lokasi Saya to destination
    final fallbackStart = const LatLng(-7.9424, 112.6220); // Soekarno Hatta
    from = "Lokasi Saya";
    currentLocation = fallbackStart;
    onStateChanged();
    await fetchOSRMRoute(fallbackStart, destinationLocation);
  }

  // ================= REALTIME GPS STREAM =================
  Future<LatLng?> initLocationStream() async {
    if (positionStream != null) return currentLocation;

    LatLng? result;
    try {
      Position initPos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 3));
      final initialLatLng = getCleanUserLocation(initPos);
      currentLocation = initialLatLng;
      currentHeading = initPos.heading;
      result = initialLatLng;
      onStateChanged();
      
      if (startLocation == null) {
        await fetchOSRMRoute(initialLatLng, destinationLocation);
      }
    } catch (e) {
      // Fallback to mock location if fails (common on emulator)
      final mockLatLng = const LatLng(-7.9424, 112.6220); // Soekarno Hatta
      currentLocation = mockLatLng;
      result = mockLatLng;
      onStateChanged();
      
      if (startLocation == null) {
        await fetchOSRMRoute(mockLatLng, destinationLocation);
      }
    }

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 20,
      ),
    ).listen((Position pos) {
      final userLatLng = getCleanUserLocation(pos);
      currentLocation = userLatLng;
      currentHeading = pos.heading;
      onStateChanged();

      if (startLocation == null) {
        fetchOSRMRoute(userLatLng, destinationLocation);
      }
    });

    return result;
  }
}
