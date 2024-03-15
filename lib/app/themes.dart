import 'package:flutter/material.dart';

final ThemeData themes = ThemeData(
  brightness: Brightness.light,
  splashColor: const Color.fromARGB(25, 253, 141, 20),
  highlightColor: const Color.fromARGB(25, 253, 141, 20),
  primaryColor: const Color.fromARGB(255, 253, 141, 20),
  bottomSheetTheme: const BottomSheetThemeData(
    surfaceTintColor: Colors.white
  ),
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.white
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 255, 90, 0),
    onPrimary: Colors.white,
    secondary: Colors.white,
    onSecondary: Colors.white,
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