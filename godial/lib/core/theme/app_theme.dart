import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Prevent instantiation
  AppTheme._();

  // Colors - Blue and White Theme
  static const Color royalBlue = Color(0xFF0052CC);
  static const Color sapphireBlue = Color(0xFF0747A6);
  static const Color azureBlue = Color(0xFF0065FF);
  static const Color skyBlue = Color(0xFF2684FF);
  static const Color iceBlue = Color(0xFF4C9AFF);
  static const Color mistBlue = Color(0xFF79B8FF);
  static const Color cloudBlue = Color(0xFFB3D4FF);
  static const Color frostBlue = Color(0xFFDEEBFF);

  // Whites & Neutrals
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color snowWhite = Color(0xFFFAFBFC);
  static const Color pearlWhite = Color(0xFFF7F8FA);
  static const Color silverWhite = Color(0xFFEBECF0);
  static const Color mistGray = Color(0xFFDFE1E6);
  static const Color cloudGray = Color(0xFFC1C7D0);
  static const Color stormGray = Color(0xFF8993A4);
  static const Color charcoalGray = Color(0xFF505F79);
  static const Color midnightGray = Color(0xFF253858);
  static const Color deepSpace = Color(0xFF091E42);

  // Semantic Colors
  static const Color successGreen = Color(0xFF00875A);
  static const Color warningOrange = Color(0xFFFF991F);
  static const Color errorRed = Color(0xFFDE350B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [royalBlue, azureBlue],
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [frostBlue, pureWhite, frostBlue],
  );

  // Text Styles
  static TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    height: 1.2,
    color: midnightGray,
  );

  static TextStyle displayMedium = GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.25,
    color: midnightGray,
  );

  static TextStyle h1 = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.3,
    color: midnightGray,
  );

  static TextStyle h2 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.35,
    color: midnightGray,
  );

  static TextStyle h3 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: midnightGray,
  );

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.6,
    color: charcoalGray,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: charcoalGray,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.45,
    color: charcoalGray,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    height: 1.4,
    color: stormGray,
  );

  static TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1,
    color: pureWhite,
  );

  // Spacing
  static const double space0 = 0;
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space8 = 32;
  static const double space10 = 40;
  static const double space12 = 48;

  // Border Radius
  static const double radiusSmall = 4;
  static const double radiusMedium = 8;
  static const double radiusLarge = 12;
  static const double radiusXLarge = 16;
  static const double radiusRound = 24;

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: royalBlue,
    scaffoldBackgroundColor: snowWhite,

    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: royalBlue,
      secondary: skyBlue,
      surface: pureWhite,
      background: snowWhite,
      error: errorRed,
      onPrimary: pureWhite,
      onSecondary: pureWhite,
      onSurface: charcoalGray,
      onBackground: charcoalGray,
      onError: pureWhite,
    ),

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: pureWhite,
      foregroundColor: midnightGray,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: h3,
      iconTheme: const IconThemeData(color: midnightGray),
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: pureWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
      ),
      shadowColor: royalBlue.withOpacity(0.08),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: royalBlue,
        foregroundColor: pureWhite,
        elevation: 2,
        shadowColor: royalBlue.withOpacity(0.3),
        minimumSize: const Size(120, 48),
        padding: const EdgeInsets.symmetric(horizontal: space4, vertical: space3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        textStyle: button,
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: royalBlue,
        padding: const EdgeInsets.symmetric(horizontal: space4, vertical: space2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        textStyle: button.copyWith(color: royalBlue),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: royalBlue,
        side: const BorderSide(color: royalBlue, width: 2),
        minimumSize: const Size(120, 48),
        padding: const EdgeInsets.symmetric(horizontal: space4, vertical: space3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        textStyle: button.copyWith(color: royalBlue),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: pearlWhite,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: space4,
        vertical: space3,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
        borderSide: const BorderSide(color: silverWhite, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
        borderSide: const BorderSide(color: silverWhite, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
        borderSide: const BorderSide(color: royalBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
        borderSide: const BorderSide(color: errorRed, width: 1.5),
      ),
      hintStyle: bodyMedium.copyWith(color: cloudGray),
      labelStyle: bodyMedium.copyWith(color: stormGray),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: pureWhite,
      selectedItemColor: royalBlue,
      unselectedItemColor: cloudGray,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: royalBlue,
      foregroundColor: pureWhite,
      elevation: 4,
      shape: CircleBorder(),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: silverWhite,
      thickness: 1,
      space: 1,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: charcoalGray,
      size: 24,
    ),
  );

  // Box Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: royalBlue.withOpacity(0.08),
      offset: const Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: royalBlue.withOpacity(0.04),
      offset: const Offset(0, 4),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: royalBlue.withOpacity(0.12),
      offset: const Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> bottomNavShadow = [
    BoxShadow(
      color: royalBlue.withOpacity(0.1),
      offset: const Offset(0, -4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
}