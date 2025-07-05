import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omt/features/auth/providers/auth_provider.dart';
import 'package:omt/features/discover/models/media_model.dart';

class ListProvider extends StateNotifier<Map<String, List<MediaModel>>> {
  ListProvider(this.ref) : super({'favourites': [], 'movies': [], 'shows': []});

  final Ref ref;
  // Future <Map<String,dynamic>>getUserList()async{
  //   await ref.read(authProvider).
  // }
  Future<void> toggleFavourite(MediaModel media) async {
    final user = ref.read(authProvider);
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('lists').doc(user.uid);
    final snapshot = await docRef.get();
    final List<dynamic> favList = snapshot.data()?['favourites'] ?? [];

    final isInList = favList.any((item) => item['id'] == media.id);
    final mediaJson = media.toJson()..remove('uid');

    try {
      if (isInList) {
        await docRef.update({
          'favourites': FieldValue.arrayRemove([mediaJson]),
          if (media.mediaType == 'movie')
            'movies': FieldValue.arrayRemove([mediaJson]),
          if (media.mediaType != 'movie')
            'shows': FieldValue.arrayRemove([mediaJson]),
        });

        state = {
          ...state,
          'favourites':
              state['favourites']!
                  .where((item) => item.id != media.id)
                  .toList(),
          if (media.mediaType == 'movie')
            'movies':
                state['movies']!.where((item) => item.id != media.id).toList(),
          if (media.mediaType != 'movie')
            'shows':
                state['shows']!.where((item) => item.id != media.id).toList(),
        };
      } else {
        await docRef.set({
          'favourites': FieldValue.arrayUnion([mediaJson]),
          if (media.mediaType == 'movie')
            'movies': FieldValue.arrayUnion([mediaJson]),
          if (media.mediaType != 'movie')
            'shows': FieldValue.arrayUnion([mediaJson]),
        }, SetOptions(merge: true));

        state = {
          ...state,
          'favourites': [...state['favourites']!, media],
          if (media.mediaType == 'movie')
            'movies': [...state['movies']!, media],
          if (media.mediaType != 'movie') 'shows': [...state['shows']!, media],
        };
      }
    } catch (e) {
      print('e');
    }
  }

  bool isFavourite(MediaModel media) {
    return state['favourites']!.any((item) => item.id == media.id);
  }

  StateProvider<bool> isFavouriteNotifier(MediaModel media) {
    return StateProvider<bool>((ref) {
      final listState = ref.watch(listProvider);
      return listState['favourites']!.any((item) => item.id == media.id);
    });
  }

  Future<Map<String, int>> getUserStats() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('lists')
              .doc(ref.read(authProvider)!.uid)
              .get();

      final data = snapshot.data() as Map<String, dynamic>;
      final shows = (data['shows'] as List?)?.length ?? 0;
      final movies = (data['movies'] as List?)?.length ?? 0;

      return {'shows': shows, 'movies': movies};
    } catch (e) {
      print('error getting user stats: $e');
      return {'shows': 0, 'movies': 0};
    }
  }
}

final listProvider =
    StateNotifierProvider<ListProvider, Map<String, List<MediaModel>>>(
      (ref) => ListProvider(ref),
    );

final userListsProvider = StreamProvider.autoDispose<Map<String, dynamic>>((
  ref,
) {
  final uid = ref.read(authProvider)!.uid;

  return FirebaseFirestore.instance
      .collection('lists')
      .doc(uid)
      .snapshots()
      .map((snapshot) => snapshot.data() ?? {});
});
