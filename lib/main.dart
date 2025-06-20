import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:omt/config/themes/dark_theme.dart';
import 'package:omt/config/themes/light_theme.dart';
import 'package:omt/features/auth/pages/sign_in.dart';

void main() async{
  await dotenv.load(fileName: '.env');
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
String get iosApiKey=>dotenv.env['IOS_API_KEY']?? 'IOS API KEY NOT FOUND';
String get androidApiKey=>dotenv.env['ANDROIDJ_API_KEY']?? 'ANDROID API KEY NOT FOUND';
String get webApiKey=>dotenv.env['WEB_API_KEY']?? 'WEB API KEY NOT FOUND';