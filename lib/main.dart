import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E - SPW',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 255, 90, 0),
          onPrimary: Colors.white,
          secondary: Color.fromARGB(255, 255, 90, 0),
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        textTheme: Typography().white.apply(fontFamily: 'Poppins'),
        brightness: Brightness.dark,
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color.fromARGB(255, 255, 90, 0),
            onPrimary: Colors.white,
            secondary: Color.fromARGB(255, 255, 90, 0),
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            background: Colors.white,
            onBackground: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black
        ),
      ),
      themeMode: ThemeMode.light,
      home: const LoginPage(title: 'E - SPW'),
      debugShowCheckedModeBanner: false,
    );
  }
}