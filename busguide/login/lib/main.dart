import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_links/app_links.dart';
import 'views/reset_password_view.dart';
// ================= SUPABASE =================
import 'package:supabase_flutter/supabase_flutter.dart';

import 'views/splash_view.dart';
import 'views/home_view.dart';
import 'controllers/login_controller.dart';
import 'package:google_fonts/google_fonts.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appLinks = AppLinks();

  appLinks.uriLinkStream.listen(
    (Uri uri) {
      if (uri.scheme == 'busguide' &&
          uri.host == 'reset-password') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) =>
                const ResetPasswordView(),
          ),
        );
      }
    },
  );

  try {
    // ================= INIT SUPABASE =================
    await Supabase.initialize(
      url: 'https://fpsyttpvekmoegrizxsl.supabase.co',
      anonKey:
          'sb_publishable_JVAIwXJBEOZi-i0OVPHGkA_PfsiMmmT',
    );

    // ================= LISTEN AUTH STATE CHANGE =================
    Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        if (LoginController.isPasswordLoginInProgress) {
          // Abaikan jika login manual (email & password) sedang berlangsung
          return;
        }

        final prefs = await SharedPreferences.getInstance();
        final isCurrentlyLogin = prefs.getBool('isLogin') ?? false;

        if (!isCurrentlyLogin) {
          final user = session.user;
          String name = '';

          try {
            final userData = await Supabase.instance.client
                .from('users')
                .select()
                .eq('id', user.id)
                .maybeSingle();
            if (userData != null) {
              name = userData['name'] ?? '';
            }
          } catch (e) {
            // Abaikan error database, fallback ke metadata
          }

          if (name.isEmpty) {
            name = user.userMetadata?['full_name'] ??
                user.userMetadata?['name'] ??
                '';
          }

          if (name.isEmpty && user.email != null) {
            name = user.email!.split('@')[0];
          }

          if (name.isEmpty) {
            name = 'Pengguna';
          }

          await prefs.setBool('isLogin', true);
          await prefs.setString('name', name);

          if (navigatorKey.currentContext != null) {
            ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                content: Text(
                  "Login berhasil",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }

          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => HomeView(name: name),
            ),
            (route) => false,
          );
        }
      }
    });

    // ================= CHECK LOGIN =================
    final prefs =
        await SharedPreferences.getInstance();

    bool isLogin =
        prefs.getBool('isLogin') ??
            false;

    String name =
        prefs.getString('name') ??
            "";

    runApp(
      MyApp(
        isLogin: isLogin,
        name: name,
      ),
    );
  } catch (e) {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner:
            false,
        home: Scaffold(
          body: Center(
            child: Text(
              "Supabase Error:\n$e",
              textAlign:
                  TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

// ================= APP =================
class MyApp extends StatelessWidget {
  final bool isLogin;
  final String name;

  const MyApp({
    super.key,
    required this.isLogin,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: SplashView(
        isLogin: isLogin,
        name: name,
      ),
    );
  }

  // ================= THEME =================
  ThemeData _buildTheme() {
    return ThemeData(
      brightness:
          Brightness.light,

      primaryColor:
          const Color(
        0xFF0056B3,
      ),

      scaffoldBackgroundColor:
          const Color(
        0xFFF5F7F9,
      ),

      cardColor: Colors.white,
    );
  }
}
