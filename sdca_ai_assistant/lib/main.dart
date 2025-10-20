import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/landing_page.dart';
import 'screens/login_page.dart';
import 'screens/assistant.dart';

void main() {
  runApp(const SdcaAiAssistantApp());
}

class SdcaAiAssistantApp extends StatelessWidget {
  const SdcaAiAssistantApp({super.key});

  static const Color primaryRed = Color(0xFFB71C1C);
  static const Color accentGold = Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme,
    );

    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        primary: primaryRed,
        secondary: accentGold,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      textTheme: textTheme,
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha:0.95),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryRed.withValues(alpha:0.25)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryRed.withValues(alpha:0.25)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryRed, width: 1.6),
        ),
        hintStyle: TextStyle(color: Colors.grey.shade500),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ).merge(
          ButtonStyle(
            overlayColor: WidgetStateProperty.all(primaryRed.withValues(alpha:0.15)),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 12,
        surfaceTintColor: Colors.white,
        shadowColor: primaryRed.withValues(alpha:0.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );

    return MaterialApp(
      title: 'SDCA AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/assistant': (context) => const AssistantPage(),
      },
    );
  }
}

