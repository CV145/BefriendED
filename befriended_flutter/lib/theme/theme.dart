import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light {
    const primary = Color.fromARGB(255, 235, 244, 248);
    const onPrimary = Color(0xff1D4B7F);
    return ThemeData(
      // appBarTheme: const AppBarTheme(
      //   color: Color(0xFF13B9FF),
      // ),
      // colorScheme: ColorScheme.fromSwatch(
      //   accentColor: Color(0xFF13B9FF),
      // ),
      // snackBarTheme: const SnackBarThemeData(
      //   behavior: SnackBarBehavior.floating,
      // ),
      // toggleableActiveColor: Color(0xFF13B9FF),
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Colors.black87),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary, //Color(0xff1D4B7F),
        secondary: Color(0xffC7E2F1),
        onSecondary: Color(0xff4C82B5),
        error: Color(0xff78C0EA),
        onError: Color(0xff000000),
        background: Color(0xff000000),
        onBackground: Color(0xff70CFEF),
        surface: Colors.white,
        onSurface: Colors.black87,
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.dosis(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: onPrimary,
        ),
        titleMedium: GoogleFonts.dosis(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: onPrimary,
        ),
        titleSmall: GoogleFonts.dosis(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: onPrimary,
        ),
        bodyMedium: GoogleFonts.dosis(
          fontSize: 20,
          letterSpacing: 1,
          color: onPrimary,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.dosis(
          fontSize: 20,
          letterSpacing: 1,
          color: onPrimary.withOpacity(0.9),
        ),
        displaySmall: GoogleFonts.dosis(
          fontSize: 14,
          letterSpacing: 1,
          color: onPrimary.withOpacity(0.9),
        ),
        // labelSmall: GoogleFonts.dosis(
        //   fontSize: 12,
        //   letterSpacing: 1,
        //   fontStyle: FontStyle.italic,
        //   color: Color(0xff50586C),
        // ),
      ),
      primaryTextTheme: TextTheme(
        titleLarge: GoogleFonts.dosis(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: primary,
        ),
        titleMedium: GoogleFonts.dosis(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: primary,
        ),
        bodyMedium: GoogleFonts.dosis(
          fontSize: 20,
          letterSpacing: 1,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.dosis(
          fontSize: 20,
          letterSpacing: 1,
          color: primary.withOpacity(0.9),
        ),
        displaySmall: GoogleFonts.dosis(
          fontSize: 14,
          letterSpacing: 1,
          color: primary.withOpacity(0.9),
        ),
        // bodySmall: GoogleFonts.dosis(
        //   fontSize: 12,
        //   letterSpacing: 1,
        //   color: Color(0xffDCE2F0),
        // ),
        // displaySmall: GoogleFonts.dosis(
        //   fontSize: 12,
        //   letterSpacing: 1,
        //   fontStyle: FontStyle.italic,
        //   color: Color(0xffDCE2F0),
        // ),
        // labelSmall: GoogleFonts.dosis(
        //   fontSize: 12,
        //   letterSpacing: 1,
        //   color: Color(0xffDCE2F0),
        // ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      // appBarTheme: const AppBarTheme(
      //   color: Color(0xFF13B9FF),
      // ),
      // colorScheme: ColorScheme.fromSwatch(
      //   brightness: Brightness.dark,
      //   accentColor: Color(0xFF13B9FF),
      // ),
      // snackBarTheme: const SnackBarThemeData(
      //   behavior: SnackBarBehavior.floating,
      // ),
      // toggleableActiveColor: Color(0xFF13B9FF),
      // textTheme: GoogleFonts.latoTextTheme(), 0xf50586C /0xffDCE2F0
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xffDCE2F0),
        onPrimary: Color(0xff50586C),
        secondary: Color(0xffd0d7f2), //0xff9aacd6
        onSecondary: Color(0xff757e99), //0xff495a86
        error: Color(0xffd0d7f2), //6c6350
        onError: Color(0xff50586C),
        background: Color(0xff9aacd6),
        onBackground: Color(0xff50586C),
        surface: Color(0xff757e99),
        onSurface: Color(0xffd0d7f2),
      ),
      textTheme: TextTheme(
        titleMedium: GoogleFonts.dosis(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: Color(0xffDCE2F0),
        ),
        titleSmall: GoogleFonts.dosis(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: Color(0xffDCE2F0),
        ),
        bodyMedium: GoogleFonts.dosis(
          fontSize: 18,
          letterSpacing: 1,
          color: Color(0xffDCE2F0),
        ),
        bodySmall: GoogleFonts.dosis(
          fontSize: 14,
          letterSpacing: 1,
          color: Color(0xffDCE2F0),
        ),
        displaySmall: GoogleFonts.dosis(
          fontSize: 12,
          letterSpacing: 1,
          color: Color(0xffDCE2F0),
        ),
        labelMedium: GoogleFonts.dosis(
          fontSize: 18,
          letterSpacing: 1,
          color: Color(0xff9aacd6),
        ),
        labelSmall: GoogleFonts.dosis(
          fontSize: 13,
          letterSpacing: 1,
          color: Color(0xff9aacd6),
        ),
      ),
      primaryTextTheme: TextTheme(
        titleMedium: GoogleFonts.dosis(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: Color(0xff50586C),
        ),
        bodyMedium: GoogleFonts.dosis(
          fontSize: 18,
          letterSpacing: 1,
          color: Color(0xff50586C),
        ),
        bodySmall: GoogleFonts.dosis(
          fontSize: 12,
          letterSpacing: 1,
          color: Color(0xff50586C),
        ),
        displaySmall: GoogleFonts.dosis(
          fontSize: 12,
          letterSpacing: 1,
          fontStyle: FontStyle.italic,
          color: Color(0xff50586C),
        ),
        labelMedium: GoogleFonts.dosis(
          fontSize: 18,
          letterSpacing: 1,
          color: Color(0xff50586C),
        ),
        labelSmall: GoogleFonts.dosis(
          fontSize: 12,
          letterSpacing: 1,
          fontStyle: FontStyle.italic,
          color: Color(0xff50586C),
        ),
      ),
    );
  }
}
