import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omt/features/discover/models/media_model.dart';
import 'package:omt/core/common/providers/dio_provider.dart';

class MediaProvider extends StateNotifier<Map<String, List<MediaModel?>>> {
  MediaProvider(this.ref) : super({});
  final Ref ref;

  Future<void> fetchAllEndpoints() async {
    final dio = ref.read(tmbdProvider);

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
      'trendingAll': trendingAll.map((json) => MediaModel.fromJson(json,'')).toList(),
      'popularMovies': popularMovies.map((json) => MediaModel.fromJson(json,'movie')).toList(),
      'popularTv': popularTv.map((json) => MediaModel.fromJson(json,'tv')).toList(),
      'nowPlayingMovies': nowPlayingMovies.map((json) => MediaModel.fromJson(json,'movie')).toList(),
      'onTheAirTv': onTheAirTv.map((json) => MediaModel.fromJson(json,'tv')).toList(),
    };

   // print(trendingAll);
  }
}

final mediaProvider = StateNotifierProvider<MediaProvider, Map<String, List<MediaModel?>>>(
  (ref) => MediaProvider(ref),
);