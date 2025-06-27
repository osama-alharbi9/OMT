import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omt/features/discover/models/cast_model.dart';
import 'package:omt/features/discover/providers/dio_provider.dart';

class CastNotifier extends StateNotifier<Map<int, List<CastModel>>> {
  CastNotifier(this.ref) : super({});
  final Ref ref;

  Future<void> fetchCast(int mediaId, String mediaType) async {
    final dio = ref.read(dioProvider);
    final response = await dio.get('$mediaType/$mediaId/credits');

    final List castJson = response.data['cast'];
    final castList = castJson.map((json) => CastModel.fromJson(json)).toList();

    state = {...state, mediaId: castList};
  }
}

final castProvider =
    StateNotifierProvider<CastNotifier, Map<int, List<CastModel>>>(
      (ref) => CastNotifier(ref),
    );
