import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omt/features/discover/models/media_item.dart';
import 'package:omt/features/discover/providers/dio_provider.dart';

class MediaProvider extends StateNotifier<Map<String, List<MediaItem?>>> {
  MediaProvider(this.ref) : super({});
  final Ref ref;

  Future<void> fetchAllEndpoints() async {
    final dio = ref.read(dioProvider);

    final response = await Future.wait([
      dio.get('trending/all/day'),
      dio.get('movie/popular'),
      dio.get('tv/popular'),
      dio.get('movie/now_playing'),
      dio.get('tv/on_the_air'),
    ]);

    final List trendingAll = response[0].data['results'];
    final List popularMovies = response[1].data['results'];
    final List popularTv = response[2].data['results'];
    final List nowPlayingMovies = response[3].data['results'];
    final List onTheAirTv = response[4].data['results'];

    state = {
      'trendingAll': trendingAll.map((json) => MediaItem.fromJson(json)).toList(),
      'popularMovies': popularMovies.map((json) => MediaItem.fromJson(json)).toList(),
      'popularTv': popularTv.map((json) => MediaItem.fromJson(json)).toList(),
      'nowPlayingMovies': nowPlayingMovies.map((json) => MediaItem.fromJson(json)).toList(),
      'onTheAirTv': onTheAirTv.map((json) => MediaItem.fromJson(json)).toList(),
    };

    print(trendingAll);
  }
}

final mediaProvider = StateNotifierProvider<MediaProvider, Map<String, List<MediaItem?>>>(
  (ref) => MediaProvider(ref),
);