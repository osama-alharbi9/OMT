import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omt/config/themes/dark_theme.dart';
import 'package:omt/config/themes/light_theme.dart';
import 'package:omt/core/common/helpers/helper_functions.dart';
import 'package:omt/features/auth/pages/sign_in.dart';
import 'package:omt/features/auth/providers/auth_provider.dart';
import 'package:omt/firebase_options.dart';
import 'package:omt/omt_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  }

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    return ScreenUtilInit(
      builder:
          (context, child) => MaterialApp(navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: user == null ? SignIn() : OmtNavigator(),
          ),
    );
  }
}

String get iosApiKey => dotenv.env['IOS_API_KEY'] ?? 'IOS API KEY NOT FOUND';
String get androidApiKey =>
    dotenv.env['ANDROIDJ_API_KEY'] ?? 'ANDROID API KEY NOT FOUND';
String get webApiKey => dotenv.env['WEB_API_KEY'] ?? 'WEB API KEY NOT FOUND';
String get tmbdApiKey=>dotenv.env['TMBD_API_KEY']??'TMBD API KEY NOT FOUND';


