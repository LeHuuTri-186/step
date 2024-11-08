import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavThemeData {
  static BottomNavigationBarThemeData get lightTheme => BottomNavigationBarThemeData(
  elevation: 20, // Adds shadow
  backgroundColor: Colors.white70, // Background color
  selectedLabelStyle: GoogleFonts.varelaRound(), // Selected label style
  unselectedLabelStyle: GoogleFonts.varelaRound(
    color: Colors.black54, // Unselected label style
  ),
  unselectedItemColor: Colors.black87, // Unselected item color
  type: BottomNavigationBarType.fixed, // Prevents shifting
  showUnselectedLabels: true, // Shows unselected labels
  );

  static BottomNavigationBarThemeData get darkTheme => BottomNavigationBarThemeData(
    elevation: 20, // Adds shadow
    backgroundColor: Colors.grey[900], // Background color
    selectedLabelStyle: GoogleFonts.varelaRound(), // Selected label style
    unselectedLabelStyle: GoogleFonts.varelaRound(
      color: Colors.white, // Unselected label style
    ),
    unselectedItemColor: Colors.white, // Unselected item color
    type: BottomNavigationBarType.fixed, // Prevents shifting
    showUnselectedLabels: true, // Shows unselected labels
  );
}