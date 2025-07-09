import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omt/features/discover/models/media_model.dart';
import 'package:omt/features/search/providers/search_provider.dart';
import 'package:omt/features/search/providers/seggustion_provider.dart';

class SearchSeggustions extends StateNotifier<List<MediaModel>> {
  final Ref ref;
  SearchSeggustions(this.ref) : super([]);

  Future<void> dailySeggustions() async {
  final suggestionsAsync = ref.read(seggustionProvider);

  if (!suggestionsAsync.hasValue || suggestionsAsync.value!.isEmpty) {
    print('AI suggestions not ready');
    return;
  }

  final suggestions = suggestionsAsync.value!;
  final searchNotifier = ref.read(searchProvider.notifier);
  final List<MediaModel> results = [];

  for (var i = 0; i < suggestions.length && i < 10; i++) {
    final query = suggestions[i];
    await searchNotifier.search(query);

    final result = ref.read(searchProvider);
    result.when(
      data: (data) {
        if (data.isNotEmpty) results.add(data[0]);
      },
      error: (_, __) => print("Search failed for $query"),
      loading: () {}, 
    );
  }

  if (results.isNotEmpty) {
    state = results;
  } else {
    print('No valid media found');
  }
}
}

final searchSeggustions = StateNotifierProvider<SearchSeggustions, List<MediaModel>>(
  (ref) => SearchSeggustions(ref),
);