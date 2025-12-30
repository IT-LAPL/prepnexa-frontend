// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth/sign_in_screen.dart';
import 'auth/sign_up_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'upload/upload_pyqs_screen.dart';
import 'auth/auth_service.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PrepNexaApp());
}

class PrepNexaApp extends StatefulWidget {
  const PrepNexaApp({super.key});

  @override
  State<PrepNexaApp> createState() => _PrepNexaAppState();
}

class _PrepNexaAppState extends State<PrepNexaApp> {
  final AuthService _auth = AuthService.instance;
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      debugShowCheckedModeBanner: false,
      title: 'PrepNexa',
      theme: AppTheme.lightTheme(ThemeData()).copyWith(
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          ThemeData(useMaterial3: true).textTheme,
        ),
      ),
      initialRoute: _auth.isLoggedIn ? '/dashboard' : '/signin',
      routes: {
        '/signin': (c) => SignInScreen(onSignedIn: _onAuthChanged),
        '/signup': (c) => SignUpScreen(onSignedUp: _onAuthChanged),
        '/dashboard': (c) => DashboardScreen(onLogout: _onLogout),
        '/upload-pyqs': (c) => const UploadPyqsScreen(),
      },
    );
  }

  void _onAuthChanged() {
    setState(() {});
    _navKey.currentState?.pushNamedAndRemoveUntil(
      _auth.isLoggedIn ? '/dashboard' : '/signin',
      (r) => false,
    );
  }

  void _onLogout() {
    _auth.logout();
    _onAuthChanged();
  }
}
