import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omt/features/discover/models/media_model.dart';
import 'package:omt/core/common/providers/dio_provider.dart';

class SearchNotifier extends StateNotifier<AsyncValue<List<MediaModel>>> {
  final Ref ref; 

  SearchNotifier(this.ref) : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final dio = ref.read(tmbdProvider);

      final res = await dio.get('search/multi', queryParameters: {
        'query': query,
      });
      
      final results = (res.data['results'] as List)
          .where((item) =>
              item['media_type'] == 'movie' || item['media_type'] == 'tv')
          .map((item) => MediaModel.fromJson(item, item['media_type']))
          .toList();

      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
final searchProvider =
    StateNotifierProvider<SearchNotifier, AsyncValue<List<MediaModel>>>(
  (ref) => SearchNotifier(ref),
);