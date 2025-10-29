import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


ThemeData buildTheme(Brightness brightness) {
final base = ThemeData(
brightness: brightness,
colorScheme: ColorScheme.fromSeed(
seedColor: const Color(0xFFE50914), // elegant red accent
brightness: brightness,
),
useMaterial3: true,
);


return base.copyWith(
textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
appBarTheme: base.appBarTheme.copyWith(
centerTitle: true,
elevation: 0,
scrolledUnderElevation: 0,
titleTextStyle: GoogleFonts.poppins(
fontWeight: FontWeight.w600,
fontSize: 18,
color: base.colorScheme.onSurface,
),
),
elevatedButtonTheme: ElevatedButtonThemeData(
style: ElevatedButton.styleFrom(
shape: const StadiumBorder(),
padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
),
),
inputDecorationTheme: InputDecorationTheme(
border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: BorderSide(color: base.colorScheme.primary, width: 1.4),
),
),
snackBarTheme: base.snackBarTheme.copyWith(
behavior: SnackBarBehavior.floating,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
),
);
}