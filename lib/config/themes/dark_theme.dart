import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFFFFEB3B), // Brand Yellow
  scaffoldBackgroundColor: Color(0xFF000000),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFFFEB3B),       // Brand Yellow
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFF6D6D6D),
    onSecondary: Color(0xFFFFFFFF),
    surface: Color(0xFF131313),
    onSurface: Color(0xFFFFFFFF),
    error: Color(0xFFFF0000),
    onError: Color(0xFFFFFFFF),
    brightness: Brightness.dark,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
    bodyMedium: TextStyle(color: Color(0xFFFFFFFF)),
  ),
);