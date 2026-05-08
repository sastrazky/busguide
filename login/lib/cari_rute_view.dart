import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CariRuteView extends StatefulWidget {
  const CariRuteView({super.key});

  @override
  State<CariRuteView> createState() => _CariRuteViewState();
}

class _CariRuteViewState extends State<CariRuteView> {
  String? asal = "Terminal A";
  String? tujuan = "Mall B";

  bool showResult = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0056B3),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Cari Rute",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER =====
            Text(
              "Temukan Rute Terbaik",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Pilih lokasi awal dan tujuanmu",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // ===== FORM =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _inputRow(
                    Icons.my_location,
                    "Lokasi Awal",
                    asal,
                    () {
                      _showPilihan(
                        context,
                        "Pilih Lokasi Awal",
                        ["Terminal A", "Terminal B", "Terminal C"],
                        (val) => setState(() => asal = val),
                      );
                    },
                  ),

                  const Divider(),

                  _inputRow(
                    Icons.location_on,
                    "Tujuan",
                    tujuan,
                    () {
                      _showPilihan(
                        context,
                        "Pilih Tujuan",
                        ["Mall A", "Mall B", "Mall C"],
                        (val) => setState(() => tujuan = val),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // ===== SWAP =====
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          final temp = asal;
                          asal = tujuan;
                          tujuan = temp;
                        });
                      },
                      icon: const Icon(
                        Icons.swap_vert,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ===== BUTTON =====
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF2F80ED),
                            Color(0xFF56CCF2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => showResult = true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          "CARI RUTE",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ===== HASIL =====
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: showResult
                  ? Column(
                      key: const ValueKey(1),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Hasil Rute",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _hasilCard("Bus A", "A → B → C", Colors.blue),
                        _hasilCard("Bus B", "D → E → F", Colors.green),
                      ],
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  // ===== INPUT =====
  Widget _inputRow(
    IconData icon,
    String title,
    String? value,
    Function() onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    value ?? "",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  // ===== BOTTOM SHEET =====
  void _showPilihan(
    BuildContext context,
    String title,
    List<String> items,
    Function(String) onSelected,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            ...items.map(
              (e) => ListTile(
                title: Text(e, style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  onSelected(e);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // ===== CARD HASIL =====
  Widget _hasilCard(String title, String route, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.directions_bus, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  route,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14),
        ],
      ),
    );
  }
}