import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Premium Color Palette - Sophisticated & Professional
  static const Color primaryColor = Color(0xFF1B4332); // Deep Forest Green
  static const Color primaryLight = Color(0xFF2D5A3D); // Medium Forest
  static const Color primaryDark = Color(0xFF0F2419); // Dark Forest

  static const Color accentColor = Color(0xFFD4A574); // Elegant Gold
  static const Color accentLight = Color(0xFFE8C5A0); // Light Gold
  static const Color accentDark = Color(0xFFB8935A); // Dark Gold

  static const Color backgroundColor = Color(
    0xFFFAFBFC,
  ); // Pure White with hint
  static const Color surfaceColor = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceElevated = Color(0xFFF8F9FA); // Slightly elevated
  static const Color surfaceContainer = Color(0xFFF1F3F5); // Container surface

  static const Color errorColor = Color(0xFFE53E3E); // Professional Red
  static const Color successColor = Color(0xFF38A169); // Success Green
  static const Color warningColor = Color(0xFFD69E2E); // Warning Amber
  static const Color infoColor = Color(0xFF3182CE); // Info Blue

  static const Color primaryTextColor = Color(0xFF1A202C); // Rich Black
  static const Color secondaryTextColor = Color(0xFF4A5568); // Medium Gray
  static const Color tertiaryTextColor = Color(0xFF718096); // Light Gray
  static const Color quaternaryTextColor = Color(0xFFA0AEC0); // Very Light Gray

  // Premium Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, primaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentColor, accentLight],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surfaceColor, surfaceElevated],
  );

  // Premium Shadows
  static List<BoxShadow> get premiumShadow => [
    BoxShadow(
      color: primaryColor.withValues(alpha: 0.08),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: primaryColor.withValues(alpha: 0.04),
      offset: const Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: primaryColor.withValues(alpha: 0.12),
      offset: const Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: primaryColor.withValues(alpha: 0.08),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get floatingShadow => [
    BoxShadow(
      color: primaryColor.withValues(alpha: 0.16),
      offset: const Offset(0, 12),
      blurRadius: 32,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: primaryColor.withValues(alpha: 0.12),
      offset: const Offset(0, 6),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  // Premium Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration extraSlowAnimation = Duration(milliseconds: 700);

  // Premium Curves
  static const Curve premiumCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeOutQuart;

  // Light Theme - Premium Edition
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,

    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      primaryContainer: primaryLight,
      secondary: accentColor,
      secondaryContainer: accentLight,
      surface: surfaceColor,
      surfaceContainer: surfaceContainer,
      error: errorColor,
      onPrimary: Colors.white,
      onPrimaryContainer: Colors.white,
      onSecondary: Colors.white,
      onSecondaryContainer: primaryTextColor,
      onSurface: primaryTextColor,
      onSurfaceVariant: secondaryTextColor,
      onError: Colors.white,
      outline: quaternaryTextColor,
      shadow: primaryColor,
    ),

    // Premium Typography using Inter
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: primaryTextColor,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: primaryTextColor,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: primaryTextColor,
        height: 1.22,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: primaryTextColor,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: primaryTextColor,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: primaryTextColor,
        height: 1.33,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: primaryTextColor,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: primaryTextColor,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: primaryTextColor,
        height: 1.43,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: primaryTextColor,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: secondaryTextColor,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: tertiaryTextColor,
        height: 1.33,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: primaryTextColor,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: secondaryTextColor,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: tertiaryTextColor,
        height: 1.45,
      ),
    ),

    // Premium ElevatedButton Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style:
          ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            minimumSize: const Size(120, 56),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.15,
            ),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.white.withValues(alpha: 0.1);
              }
              if (states.contains(WidgetState.hovered)) {
                return Colors.white.withValues(alpha: 0.05);
              }
              return null;
            }),
          ),
    ),

    // Premium Card Theme
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: quaternaryTextColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.all(8),
    ),

    // Premium AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: primaryTextColor,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        letterSpacing: 0,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),

    // Premium InputDecoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceElevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: quaternaryTextColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: secondaryTextColor,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: tertiaryTextColor,
      ),
    ),
  );

  // Dark Theme - Premium Edition
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryLight,
    scaffoldBackgroundColor: const Color(0xFF0F1419),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4CAF50),
      primaryContainer: Color(0xFF2E7D32),
      secondary: accentLight,
      secondaryContainer: accentColor,
      surface: Color(0xFF1A1F24),
      surfaceContainer: Color(0xFF242A30),
      error: Color(0xFFEF5350),
      onPrimary: Colors.black,
      onPrimaryContainer: Colors.white,
      onSecondary: Colors.black,
      onSecondaryContainer: Colors.white,
      onSurface: Color(0xFFE4E7EB),
      onSurfaceVariant: Color(0xFFB0BEC5),
      onError: Colors.white,
      outline: Color(0xFF455A64),
      shadow: Colors.black,
    ),

    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: const Color(0xFFE4E7EB),
        height: 1.12,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: const Color(0xFFE4E7EB),
        height: 1.25,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: const Color(0xFFE4E7EB),
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: const Color(0xFFB0BEC5),
        height: 1.43,
      ),
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF1A1F24),
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: const Color(0xFF455A64).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.all(8),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.black,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        minimumSize: const Size(120, 56),
      ),
    ),
  );
}
