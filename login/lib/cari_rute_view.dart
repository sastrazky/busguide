import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CariRuteView extends StatefulWidget {
  const CariRuteView({super.key});

  @override
  State<CariRuteView> createState() =>
      _CariRuteViewState();
}

class _CariRuteViewState
    extends State<CariRuteView> {

  String? asal = "Terminal A";
  String? tujuan = "Mall B";

  bool showResult = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7F9),

      appBar: AppBar(
        elevation: 0,

        backgroundColor:
            const Color(0xFF0056B3),

        iconTheme:
            const IconThemeData(
          color: Colors.white,
        ),

        title: Text(
          "Cari Rute",

          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // ================= HEADER =================
            Container(
              width: double.infinity,

              padding: const EdgeInsets.fromLTRB(
                20,
                25,
                20,
                35,
              ),

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end:
                      Alignment.bottomRight,

                  colors: [
                    Color(0xFF0056B3),
                    Color(0xFF2F80ED),
                  ],
                ),

                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(35),

                  bottomRight:
                      Radius.circular(35),
                ),
              ),

              child: Column(
                children: [

                  // ================= ICON =================
                  Container(
                    padding:
                        const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color:
                          Colors.white.withOpacity(
                        0.15,
                      ),

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.route_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Temukan Rute Terbaik",

                    textAlign: TextAlign.center,

                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Cari jalur bus tercepat dan ternyaman menuju tujuanmu.",
                    textAlign: TextAlign.center,

                    style: GoogleFonts.poppins(
                      color:
                          Colors.white.withOpacity(
                        0.9,
                      ),

                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(16),

              child: Column(
                children: [

                  // ================= FORM =================
                  Container(
                    padding:
                        const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        24,
                      ),

                      boxShadow: [

                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.05),

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

                              [
                                "Terminal A",
                                "Terminal B",
                                "Terminal C",
                              ],

                              (val) => setState(
                                () => asal = val,
                              ),
                            );
                          },
                        ),

                        Padding(
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 6,
                          ),

                          child: Divider(
                            color: Colors.grey
                                .withOpacity(0.2),
                          ),
                        ),

                        _inputRow(
                          Icons.location_on,
                          "Tujuan",
                          tujuan,

                          () {

                            _showPilihan(
                              context,
                              "Pilih Tujuan",

                              [
                                "Mall A",
                                "Mall B",
                                "Mall C",
                              ],

                              (val) => setState(
                                () =>
                                    tujuan = val,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // ================= SWAP =================
                        GestureDetector(
                          onTap: () {

                            setState(() {

                              final temp =
                                  asal;

                              asal = tujuan;
                              tujuan = temp;
                            });
                          },

                          child: Container(
                            padding:
                                const EdgeInsets.all(
                              14,
                            ),

                            decoration:
                                BoxDecoration(
                              gradient:
                                  const LinearGradient(
                                colors: [
                                  Color(
                                      0xFF2F80ED),
                                  Color(
                                      0xFF56CCF2),
                                ],
                              ),

                              shape:
                                  BoxShape.circle,

                              boxShadow: [

                                BoxShadow(
                                  color: Colors.blue
                                      .withOpacity(
                                    0.3,
                                  ),

                                  blurRadius: 10,
                                ),
                              ],
                            ),

                            child: const Icon(
                              Icons.swap_vert,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // ================= BUTTON =================
                        SizedBox(
                          width: double.infinity,

                          child: Container(
                            decoration:
                                BoxDecoration(
                              gradient:
                                  const LinearGradient(
                                colors: [
                                  Color(
                                      0xFF2F80ED),
                                  Color(
                                      0xFF56CCF2),
                                ],
                              ),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                30,
                              ),

                              boxShadow: [

                                BoxShadow(
                                  color: Colors.blue
                                      .withOpacity(
                                    0.3,
                                  ),

                                  blurRadius: 12,
                                ),
                              ],
                            ),

                            child: ElevatedButton(
                              onPressed: () {

                                setState(
                                  () => showResult =
                                      true,
                                );
                              },

                              style: ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                    Colors
                                        .transparent,

                                shadowColor:
                                    Colors
                                        .transparent,

                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),

                              child: Text(
                                "CARI RUTE",

                                style:
                                    GoogleFonts.poppins(
                                  fontWeight:
                                      FontWeight
                                          .w600,

                                  color:
                                      Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= RESULT =================
                  AnimatedSwitcher(
                    duration:
                        const Duration(
                      milliseconds: 400,
                    ),

                    child: showResult

                        ? Column(
                            key:
                                const ValueKey(1),

                            children: [

                              Align(
                                alignment:
                                    Alignment
                                        .centerLeft,

                                child: Text(
                                  "Rekomendasi Rute",

                                  style:
                                      GoogleFonts
                                          .poppins(
                                    fontWeight:
                                        FontWeight
                                            .w600,

                                    fontSize: 17,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  height: 12),

                              _hasilCard(
                                "Bus A",
                                "Terminal A → Mall B",
                                "25 Menit",
                                Colors.blue,
                              ),

                              _hasilCard(
                                "Bus B",
                                "Terminal A → Mall B",
                                "30 Menit",
                                Colors.green,
                              ),

                              _hasilCard(
                                "Bus C",
                                "Terminal A → Mall B",
                                "40 Menit",
                                Colors.orange,
                              ),
                            ],
                          )

                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= INPUT =================
  Widget _inputRow(
    IconData icon,
    String title,
    String? value,
    Function() onTap,
  ) {

    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(14),

      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          vertical: 12,
        ),

        child: Row(
          children: [

            Container(
              padding:
                  const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color:
                    Colors.blue.withOpacity(0.1),

                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),

              child: Icon(
                icon,
                color:
                    const Color(0xFF0056B3),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    title,

                    style:
                        GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    value ?? "",

                    style:
                        GoogleFonts.poppins(
                      fontWeight:
                          FontWeight.w600,

                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.keyboard_arrow_down,
            ),
          ],
        ),
      ),
    );
  }

  // ================= BOTTOM SHEET =================
  void _showPilihan(
    BuildContext context,
    String title,
    List<String> items,
    Function(String) onSelected,
  ) {

    showModalBottomSheet(
      context: context,

      backgroundColor: Colors.white,

      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),

      builder: (_) {

        return Padding(
          padding:
              const EdgeInsets.all(20),

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                title,

                style:
                    GoogleFonts.poppins(
                  fontWeight:
                      FontWeight.w600,

                  fontSize: 17,
                ),
              ),

              const SizedBox(height: 15),

              ...items.map(

                (e) => ListTile(
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),

                  leading: const Icon(
                    Icons.location_on,
                    color:
                        Color(0xFF0056B3),
                  ),

                  title: Text(
                    e,

                    style:
                        GoogleFonts.poppins(),
                  ),

                  onTap: () {

                    Navigator.pop(context);

                    onSelected(e);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= HASIL CARD =================
  Widget _hasilCard(
    String title,
    String route,
    String time,
    Color color,
  ) {

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        boxShadow: [

          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),

            blurRadius: 12,
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            padding:
                const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color:
                  color.withOpacity(0.1),

              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),

            child: Icon(
              Icons.directions_bus,
              color: color,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style:
                      GoogleFonts.poppins(
                    fontWeight:
                        FontWeight.w600,

                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  route,

                  style:
                      GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  time,

                  style:
                      GoogleFonts.poppins(
                    color: color,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios,
            size: 15,
          ),
        ],
      ),
    );
  }
}