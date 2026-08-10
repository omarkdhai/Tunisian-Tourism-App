import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors based on modern glassmorphic/sleek reference
  static const Color primaryColor = Color(0xFF1E1E1E); // Dark charcoal for main accents
  static const Color backgroundColor = Color(0xFFF3F4F6); // Soft off-white
  static const Color cardColor = Colors.white; // Pure white for cards
  static const Color textPrimaryColor = Color(0xFF111827); // Near black
  static const Color textSecondaryColor = Color(0xFF6B7280); // Gray text
  static const Color primaryIconColor = Color(0xFF1E1E1E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        surface: backgroundColor,
        onSurface: textPrimaryColor,
        secondary: primaryColor.withOpacity(0.8),
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
            color: textPrimaryColor, fontWeight: FontWeight.bold, fontSize: 32),
        headlineMedium: GoogleFonts.inter(
            color: textPrimaryColor, fontWeight: FontWeight.w700, fontSize: 24),
        titleLarge: GoogleFonts.inter(
            color: textPrimaryColor, fontWeight: FontWeight.w600, fontSize: 20),
        bodyLarge: GoogleFonts.inter(
            color: textPrimaryColor, fontWeight: FontWeight.w400, fontSize: 16),
        bodyMedium: GoogleFonts.inter(
            color: textSecondaryColor, fontWeight: FontWeight.w400, fontSize: 14),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryIconColor),
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // High radius for modern look
          ),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: GoogleFonts.inter(color: textSecondaryColor),
      ),
    );
  }
}
