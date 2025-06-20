import 'package:flutter/material.dart';
import 'package:omt/config/themes/dark_theme.dart';
import 'package:omt/config/themes/light_theme.dart';
import 'package:omt/features/auth/pages/sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: SignIn(),
    );
  }
}
