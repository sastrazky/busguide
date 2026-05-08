import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class PetaRuteView extends StatefulWidget {
  const PetaRuteView({super.key});

  @override
  State<PetaRuteView> createState() => _PetaRuteViewState();
}

class _PetaRuteViewState extends State<PetaRuteView> {
  final MapController _mapController = MapController();

  double _currentZoom = 13;

  final LatLng _centerMap =
      LatLng(-7.966620, 112.632629);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Peta Rute",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Stack(
        children: [
          // ================= MAP =================
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,

              options: MapOptions(
                initialCenter: _centerMap,
                initialZoom: _currentZoom,
              ),

              children: [
                // ================= TILE =================
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'com.example.login',
                ),

                // ================= ROUTE =================
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [
                        LatLng(
                            -7.966620, 112.632629),
                        LatLng(
                            -7.972000, 112.635000),
                        LatLng(
                            -7.978000, 112.640000),
                      ],
                      strokeWidth: 5,
                      color: Colors.blue,
                    ),
                  ],
                ),

                // ================= MARKERS =================
                MarkerLayer(
                  markers: [
                    // HALTE A
                    Marker(
                      point: LatLng(
                          -7.966620, 112.632629),
                      width: 80,
                      height: 80,
                      child: Column(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue
                                      .withOpacity(0.4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.circular(
                                      6),
                            ),
                            child: Text(
                              "Halte A",
                              style:
                                  GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // HALTE B
                    Marker(
                      point: LatLng(
                          -7.978000, 112.640000),
                      width: 80,
                      height: 80,
                      child: Column(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red
                                      .withOpacity(0.4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.circular(
                                      6),
                            ),
                            child: Text(
                              "Halte B",
                              style:
                                  GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // USER
                    Marker(
                      point: LatLng(
                          -7.972000, 112.635000),
                      width: 70,
                      height: 70,
                      child: Container(
                        padding:
                            const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green
                                  .withOpacity(0.4),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ================= GRADIENT =================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x99000000),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // ================= MAP BUTTON =================
          Positioned(
            right: 16,
            bottom: 180,
            child: Column(
              children: [
                // ZOOM IN
                _mapButton(
                  Icons.add,
                  () {
                    _currentZoom++;
                    _mapController.move(
                      _mapController.camera.center,
                      _currentZoom,
                    );
                  },
                ),

                const SizedBox(height: 10),

                // ZOOM OUT
                _mapButton(
                  Icons.remove,
                  () {
                    _currentZoom--;
                    _mapController.move(
                      _mapController.camera.center,
                      _currentZoom,
                    );
                  },
                ),

                const SizedBox(height: 10),

                // MY LOCATION
                _mapButton(
                  Icons.my_location,
                  () {
                    _mapController.move(
                      _centerMap,
                      13,
                    );
                  },
                ),
              ],
            ),
          ),

          // ================= BOTTOM CARD =================
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _bottomCard(),
          ),
        ],
      ),
    );
  }

  // ================= BUTTON =================
  Widget _mapButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: Colors.black87,
        ),
      ),
    );
  }

  // ================= BOTTOM CARD =================
  Widget _bottomCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HANDLE
          Container(
            width: 40,
            height: 4,
            margin:
                const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius:
                  BorderRadius.circular(10),
            ),
          ),

          // INFO
          Row(
            children: [
              const Icon(
                Icons.directions_bus,
                color: Colors.blue,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Halte A → Halte B",
                  style: GoogleFonts.poppins(
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF0056B3),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                          12),
                ),
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 14,
                ),
              ),
              child: Text(
                "Mulai Navigasi",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}