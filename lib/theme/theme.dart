import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlutterCoffeePicturesTheme {
  static ThemeData get light {
    const white = Color(0xfffffbfc);
    const brown = Color(0xff9c6644);
    const brownShade = Color(0xff86573B);
    const brownComplementary = Color(0xff447A9C);

    return ThemeData(
      fontFamily: GoogleFonts.aBeeZee().fontFamily,
      scaffoldBackgroundColor: white,
      appBarTheme: AppBarTheme(
        color: white,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
        titleTextStyle: GoogleFonts.abhayaLibre(fontSize: 24, color: brown),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          backgroundColor: white.withOpacity(.87),
          side: const BorderSide(
            color: Colors.black12,
            width: 2,
          ),
          foregroundColor: brownShade,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(accentColor: brownComplementary),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      toggleableActiveColor: brown,
    );
  }

  static ThemeData get dark {
    const black = Color(0xff30332E);
    const brown = Color(0xfffefae0);
    const brownShade = Color(0xff211D01);
    const brownTint = Color(0xffFEFBE6);
    const brownComplementary = Color(0xffE1E5FE);

    return ThemeData(
      fontFamily: GoogleFonts.aBeeZee().fontFamily,
      scaffoldBackgroundColor: black,
      appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.abhayaLibre(fontSize: 24, color: brown),
        color: black,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          backgroundColor: brownShade.withOpacity(.24),
          side: const BorderSide(
            color: Colors.black12,
            width: 2,
          ),
          foregroundColor: brownTint,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        accentColor: brownComplementary,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      toggleableActiveColor: brown,
    );
  }
}
