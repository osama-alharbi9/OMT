import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omt/core/common/providers/dio_provider.dart';

class SeggustionProvider extends StateNotifier<AsyncValue<List<String>>> {
  final Ref ref;

  SeggustionProvider(this.ref) : super(const AsyncValue.data([]));

  void aiSeggustion(List<String> titles) async {
    final dio = ref.read(openAiProvider);

    final prompt =
        'Give me a plain list of 10 similar movies or TV shows to the following titles. Respond with titles only, no description,no numbering, titles only:\n${titles.join(", ")}';

    state = const AsyncValue.loading();
    try {
      final response = await dio.post(
        'https://api.openai.com/v1/chat/completions',
        data: {
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content": "You are a helpful movie recommender.",
            },
            {"role": "user", "content": prompt},
          ],
        },
      );

      final choices = response.data['choices'] as List;
      final content = choices.first['message']['content'] as String;

      final suggestions =
          content.split('\n').where((e) => e.trim().isNotEmpty).toList();
      print(suggestions);
      state = AsyncValue.data(suggestions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final seggustionProvider =
    StateNotifierProvider<SeggustionProvider, AsyncValue<List<String>>>(
      (ref) => SeggustionProvider(ref),
    );
