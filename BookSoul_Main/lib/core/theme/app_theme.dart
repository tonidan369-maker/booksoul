import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const ink = Color(0xFF1F2E36);
  static const teal = Color(0xFF1E6A63);
  static const deepTeal = Color(0xFF164945);
  static const sand = Color(0xFFF8F5EE);
  static const gold = Color(0xFFD99D4B);
  static const mint = Color(0xFFDDEEE9);
  static const rose = Color(0xFFF1E4DF);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: teal, brightness: Brightness.light).copyWith(surface: Colors.white, primary: teal, secondary: gold);
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: sand,
      colorScheme: scheme,
      textTheme: GoogleFonts.cairoTextTheme().apply(bodyColor: ink, displayColor: ink),
      appBarTheme: const AppBarTheme(backgroundColor: sand, foregroundColor: ink, elevation: 0, centerTitle: false, surfaceTintColor: Colors.transparent),
      cardTheme: CardThemeData(color: Colors.white, elevation: 0, margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFE6E5E0))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: teal, width: 1.5))),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: teal, foregroundColor: Colors.white, minimumSize: const Size(0, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), textStyle: const TextStyle(fontWeight: FontWeight.bold))),
      navigationBarTheme: NavigationBarThemeData(backgroundColor: Colors.white, indicatorColor: mint, labelTextStyle: WidgetStateProperty.all(const TextStyle(fontWeight: FontWeight.bold))),
      dividerTheme: const DividerThemeData(color: Color(0xFFECE9E2)),
    );
  }
}
