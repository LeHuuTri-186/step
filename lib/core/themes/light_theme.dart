import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bottom_nav_theme.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,

      appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.varelaRound(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey[900],
        ),
        elevation: 2,
      ),

      textTheme: TextTheme(
        displayLarge: GoogleFonts.aBeeZee(fontWeight: FontWeight.w800, fontSize: 40, color: Colors.black),
        displayMedium: GoogleFonts.aBeeZee(fontWeight: FontWeight.w800, fontSize: 30, color: Colors.black),
        headlineLarge: GoogleFonts.varelaRound(fontSize: 96, fontWeight: FontWeight.bold, color: Colors.black),
        headlineSmall: GoogleFonts.varelaRound(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        bodyLarge:  GoogleFonts.aBeeZee(fontWeight: FontWeight.w800, fontSize: 16,),
        bodyMedium:  GoogleFonts.aBeeZee(fontSize: 13, color: Colors.grey[800]),
      ),

      bottomNavigationBarTheme: BottomNavThemeData.lightTheme,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          textStyle: GoogleFonts.varelaRound(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}