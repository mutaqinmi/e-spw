import 'package:flutter/material.dart';

final ThemeData themes = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color.fromARGB(255, 253, 143, 24),
  bottomSheetTheme: const BottomSheetThemeData(
    surfaceTintColor: Colors.transparent,
  ),
  chipTheme: const ChipThemeData(
    elevation: 4,
    surfaceTintColor: Colors.transparent,
  ),
  filledButtonTheme: const FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 253, 143, 24)),
    ),
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 253, 143, 24),
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 243, 221, 198),
    onSecondary: Color.fromARGB(255, 183, 110, 33),
    error: Colors.red,
    onError: Colors.white,
    background: Colors.white,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  useMaterial3: true,
  fontFamily: 'Poppins',
);