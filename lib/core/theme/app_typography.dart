import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.nunito(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
    ),
    displayMedium: GoogleFonts.nunito(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
    ),
    displaySmall: GoogleFonts.nunito(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.nunito(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.nunito(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.nunito(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: GoogleFonts.nunito(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: GoogleFonts.nunito(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    labelLarge: GoogleFonts.nunito(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ),
  );
}
