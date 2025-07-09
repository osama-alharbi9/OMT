import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omt/main.dart';

final tmbdProvider = Provider(
  (ref) => Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Authorization': 'Bearer $tmbdApiKey'},
    ),
  ),
);

final openAiProvider = Provider(
  (ref) => Dio(
    BaseOptions(
      baseUrl: 'https://api.openai.com/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Authorization': 'Bearer $openAiApiKey'},
    ),
  ),
);
