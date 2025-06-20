import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFFFFFFFF),
  scaffoldBackgroundColor: Color(0xFFFFFFFF),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFFFFFFF),
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFFB0B0B0),
    onSecondary: Color(0xFF000000),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF000000),
    error: Color(0xFFFF0000),
    onError: Color(0xFFFFFFFF),
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF000000)),
    bodyMedium: TextStyle(color: Color(0xFF000000)),
  ),
);