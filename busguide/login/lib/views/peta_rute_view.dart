import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart' hide Path;
import '../controllers/peta_rute_controller.dart';

class PetaRuteView extends StatefulWidget {
  final LatLng? startLocation;
  final LatLng? destinationLocation;
  final String? startName;
  final String? destinationName;

  const PetaRuteView({
    super.key,
    this.startLocation,
    this.destinationLocation,
    this.startName,
    this.destinationName,
  });

  @override
  State<PetaRuteView> createState() => _PetaRuteViewState();
}

class _PetaRuteViewState extends State<PetaRuteView> with WidgetsBindingObserver, TickerProviderStateMixin {
  final MapController _mapController = MapController();
  late final PetaRuteController _controller;
  AnimationController? _activeAnimationController;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _controller = PetaRuteController(
      onStateChanged: () {
        if (mounted) {
          setState(() {});
          if (_controller.isTrackingUser && _controller.currentLocation != null && !_isAnimating) {
            try {
              double targetRotation = 0.0;
              if (_controller.gpsMode == GpsMode.compass) {
                targetRotation = -_controller.currentHeading;
              }
              _mapController.move(_controller.currentLocation!, _mapController.camera.zoom);
              _mapController.rotate(targetRotation);
            } catch (_) {
              // MapController not ready yet
            }
          }
        }
      },
      destinationLocation: widget.destinationLocation ?? const LatLng(-7.944900, 112.611400),
      startLocation: widget.startLocation,
      startName: widget.startName,
      destinationName: widget.destinationName,
    );
    
    _controller.loadRoute();
    _controller.checkGpsAndInit();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _activeAnimationController?.stop();
    _activeAnimationController?.dispose();
    _controller.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _animatedMapMove(LatLng destCenter, double destZoom, double destRotation) {
    _activeAnimationController?.stop();
    _activeAnimationController?.dispose();
    _activeAnimationController = null;

    final camera = _mapController.camera;
    final LatLng startCenter = camera.center;
    final double startZoom = camera.zoom;
    final double startRotation = camera.rotation;

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _activeAnimationController = controller;
    _isAnimating = true;

    final latTween = Tween<double>(begin: startCenter.latitude, end: destCenter.latitude);
    final lngTween = Tween<double>(begin: startCenter.longitude, end: destCenter.longitude);
    final zoomTween = Tween<double>(begin: startZoom, end: destZoom);

    double diffRotation = destRotation - startRotation;
    diffRotation = (diffRotation + 180) % 360 - 180;
    final rotationTween = Tween<double>(begin: startRotation, end: startRotation + diffRotation);

    final Animation<double> curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );

    controller.addListener(() {
      if (!mounted) return;
      try {
        _mapController.move(
          LatLng(latTween.evaluate(curvedAnimation), lngTween.evaluate(curvedAnimation)),
          zoomTween.evaluate(curvedAnimation),
        );
        _mapController.rotate(rotationTween.evaluate(curvedAnimation));
      } catch (_) {}
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        _isAnimating = false;
        if (_activeAnimationController == controller) {
          _activeAnimationController = null;
        }
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller.checkGpsAndInit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: _controller.isLoading ? _buildLoading() : _buildBody(),
    );
  }

  // ================= APPBAR =================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
    );
  }

  // ================= LOADING =================
  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // ================= BODY =================
  Widget _buildBody() {
    return Stack(
      children: [
        _buildMap(),
        _buildTopOverlay(),
        _buildDraggableSheet(),
        _buildFloatingButtons(),
      ],
    );
  }

  // ================= MAP =================
  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _controller.currentLocation ??
            (_controller.routePoints.isNotEmpty ? _controller.routePoints.first : const LatLng(-7.943100, 112.618900)),
        initialZoom: 13.5,
        onPositionChanged: (position, hasGesture) {
          if (hasGesture && !_isAnimating) {
            _activeAnimationController?.stop();
            _activeAnimationController?.dispose();
            _activeAnimationController = null;
            
            if (_controller.gpsMode != GpsMode.none) {
              setState(() {
                _controller.gpsMode = GpsMode.none;
              });
            }
          }
        },
      ),
      children: [
        _buildTileLayer(),
        _buildShadowPolyline(),
        _buildMainPolyline(),
        _buildMarkerLayer(),
      ],
    );
  }

  // ================= TILE =================
  Widget _buildTileLayer() {
    return TileLayer(
      urlTemplate: 'https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.busguide',
      maxZoom: 20,
      retinaMode: true,
      tileProvider: NetworkTileProvider(),
    );
  }

  // ================= SHADOW =================
  Widget _buildShadowPolyline() {
    if (_controller.routePoints.isEmpty) return const SizedBox.shrink();

    return PolylineLayer(
      polylines: [
        Polyline(
          points: _controller.routePoints,
          strokeWidth: 12,
          color: Colors.blue.withOpacity(0.15),
        ),
      ],
    );
  }

  // ================= MAIN =================
  Widget _buildMainPolyline() {
    if (_controller.routePoints.isEmpty) return const SizedBox.shrink();

    return PolylineLayer(
      polylines: [
        Polyline(
          points: _controller.routePoints,
          strokeWidth: 6,
          color: const Color(0xFF0056B3),
        ),
      ],
    );
  }

  // ================= MARKER =================
  Widget _buildMarkerLayer() {
    return MarkerLayer(
      markers: [
        // ================= USER =================
        if (_controller.currentLocation != null)
          Marker(
            point: _controller.currentLocation!,
            width: 80,
            height: 80,
            rotate: true,
            child: _buildUserLocationMarker(),
          ),

        // ================= START =================
        if (widget.startLocation != null)
          Marker(
            point: widget.startLocation!,
            width: 80,
            height: 80,
            child: _marker(
              icon: Icons.directions_bus,
              color: Colors.green,
              title: _controller.from,
            ),
          ),

        // ================= DESTINATION =================
        if (_controller.routePoints.isNotEmpty)
          Marker(
            point: _controller.routePoints.last,
            width: 80,
            height: 80,
            child: _marker(
              icon: Icons.location_on,
              color: Colors.red,
              title: _controller.to,
            ),
          ),
      ],
    );
  }

  // ================= TOP OVERLAY =================
  Widget _buildTopOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 170,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xAA000000),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  // ================= FLOATING =================
  Widget _buildFloatingButtons() {
    return Positioned(
      right: 18,
      bottom: 220,
      child: Column(
        children: [
          _floatingButton(
            _controller.gpsMode == GpsMode.compass
                ? Icons.explore
                : (_controller.gpsMode == GpsMode.follow ? Icons.gps_fixed : Icons.gps_not_fixed),
            () async {
              LatLng? loc = _controller.currentLocation;

              if (!_controller.isPermissionGranted || loc == null) {
                loc = await _controller.checkGpsAndInit();
              }

              if (!mounted) return;

              if (loc != null) {
                GpsMode nextMode;
                if (_controller.gpsMode == GpsMode.none) {
                  nextMode = GpsMode.follow;
                } else if (_controller.gpsMode == GpsMode.follow) {
                  nextMode = GpsMode.compass;
                } else {
                  nextMode = GpsMode.follow;
                }

                setState(() {
                  _controller.gpsMode = nextMode;
                });

                double targetRotation = 0.0;
                if (nextMode == GpsMode.compass) {
                  targetRotation = -_controller.currentHeading;
                }

                _animatedMapMove(loc, 17.5, targetRotation);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Lokasi Anda tidak tersedia. Harap aktifkan GPS dan izinkan akses lokasi.",
                      style: GoogleFonts.poppins(),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            isActive: _controller.gpsMode != GpsMode.none,
          ),
        ],
      ),
    );
  }

  // ================= DRAG =================
  Widget _buildDraggableSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.15,
      minChildSize: 0.15,
      maxChildSize: 0.65,
      snap: true,
      snapSizes: const [
        0.15,
        0.35,
        0.65,
      ],
      builder: (context, scrollController) {
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.98, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: _buildSheetContent(scrollController),
        );
      },
    );
  }

  // ================= SHEET =================
  Widget _buildSheetContent(ScrollController scrollController) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),
            _buildTopInfo(),
            const SizedBox(height: 26),
            _buildInfoRow(),
            const SizedBox(height: 28),
            _buildRouteDetail(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ================= HANDLE =================
  Widget _buildHandle() {
    return Container(
      width: 55,
      height: 6,
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade400,
            Colors.grey.shade300,
          ],
        ),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  // ================= TOP INFO =================
  Widget _buildTopInfo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF2F80ED),
                Color(0xFF56CCF2),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.25),
                blurRadius: 12,
              ),
            ],
          ),
          child: const Icon(
            Icons.directions_bus,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _controller.from,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Menuju ${_controller.to}",
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= INFO ROW =================
  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _infoItem(
            Icons.access_time,
            _controller.duration,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _infoItem(
            Icons.route,
            _controller.distance,
          ),
        ),
      ],
    );
  }

  // ================= DETAIL =================
  Widget _buildRouteDetail() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F9),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          _routeTile(
            _controller.from,
            Icons.my_location,
            Colors.green,
          ),
          _routeDivider(),
          _routeTile(
            _controller.to,
            Icons.location_on,
            Colors.red,
          ),
        ],
      ),
    );
  }

  // ================= MARKER =================
  Widget _marker({
    required IconData icon,
    required Color color,
    required String title,
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
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 14,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ================= GOOGLE MAPS USER BLUE DOT =================
  Widget _buildUserLocationMarker() {
    return Stack(
      alignment: Alignment.center,
      children: [
        UserDirectionCone(heading: _controller.currentHeading),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF4285F4).withOpacity(0.25),
          ),
        ),
        Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF4285F4),
          ),
        ),
      ],
    );
  }

  // ================= FLOAT BUTTON =================
  Widget _floatingButton(
    IconData icon,
    VoidCallback onTap, {
    required bool isActive,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: isActive ? const Color(0xFF0056B3) : const Color(0xFF5F6368),
        ),
      ),
    );
  }

  // ================= INFO ITEM =================
  Widget _infoItem(
    IconData icon,
    String text,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0056B3).withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF0056B3),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // ================= ROUTE TILE =================
  Widget _routeTile(
    String title,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ================= DIVIDER =================
  Widget _routeDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 20,
      ),
      child: Container(
        height: 1,
        color: Colors.grey.withOpacity(0.2),
      ),
    );
  }
}

class UserDirectionCone extends StatelessWidget {
  final double heading;

  const UserDirectionCone({super.key, required this.heading});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: heading * pi / 180,
      alignment: Alignment.center,
      child: CustomPaint(
        size: const Size(80, 80),
        painter: DirectionConePainter(),
      ),
    );
  }
}

class DirectionConePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF4285F4).withOpacity(0.35),
          const Color(0xFF4285F4).withOpacity(0.0),
        ],
        stops: const [0.1, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    
    double radius = size.height / 2;
    double startAngle = -90 - 25; // 0 is right, -90 is up.
    double sweepAngle = 50;
    
    path.moveTo(centerX, centerY);
    path.arcTo(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle * pi / 180,
      sweepAngle * pi / 180,
      false,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}