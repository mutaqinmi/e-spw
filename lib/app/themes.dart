import 'package:flutter/material.dart';

const Color primaryColor = Color.fromARGB(255, 253, 143, 24);
const Color secondaryColor = Color.fromARGB(255, 183, 110, 33);

final ThemeData themes = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  bottomSheetTheme: const BottomSheetThemeData(
    surfaceTintColor: Colors.transparent,
  ),
  chipTheme: const ChipThemeData(
    elevation: 4,
    surfaceTintColor: Colors.transparent,
  ),
  filledButtonTheme: const FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(primaryColor),
    ),
  ),
  outlinedButtonTheme: const OutlinedButtonThemeData(
    style: ButtonStyle(
      side: WidgetStatePropertyAll(BorderSide(
        color: primaryColor
      ))
    )
  ),
  badgeTheme: const BadgeThemeData(
    backgroundColor: primaryColor,
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 243, 221, 198),
    onSecondary: Color.fromARGB(255, 183, 110, 33),
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  useMaterial3: true,
  fontFamily: 'Poppins',
);