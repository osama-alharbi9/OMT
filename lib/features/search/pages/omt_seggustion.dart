import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omt/core/common/helpers/helper_functions.dart';
import 'package:omt/features/auth/providers/auth_provider.dart';
import 'package:omt/features/search/providers/search_seggustions.dart';
import 'package:omt/features/search/providers/seggustion_provider.dart';

class OmtSeggustion extends ConsumerStatefulWidget {
  const OmtSeggustion({super.key});

  @override
  ConsumerState<OmtSeggustion> createState() => _OmtSeggustionState();
}

class _OmtSeggustionState extends ConsumerState<OmtSeggustion> {
  late List<String> titles = [];
  late Map<String, dynamic>? list;

  @override
  void initState() {
    super.initState();
    _fetchUserListAndSuggest();
  }

  Future<void> _fetchUserListAndSuggest() async {
    final user = ref.read(authProvider.notifier);

    try {
      final doc =
          await user.dataBase
              .collection('lists')
              .doc(user.auth.currentUser!.uid)
              .get();

      list = doc.data();
      if (list == null) return;

      final favourites = list!['favourites'];
      if (favourites is! List || favourites.isEmpty) return;

      titles = favourites.map((e) => e.toString()).toList();

      ref.read(seggustionProvider.notifier).aiSeggustion(titles);

      while (true) {
        final segg = ref.read(seggustionProvider);
        if (segg.hasValue && segg.value!.isNotEmpty) break;
        await Future.delayed(const Duration(milliseconds: 100));
      }

      await ref.read(searchSeggustions.notifier).dailySeggustions();
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final seggustions = ref.watch(searchSeggustions);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text("Suggestions"), pinned: true),
          SliverToBoxAdapter(
            child:
                seggustions.isEmpty
                    ? const SizedBox(
                      height: 300,
                      child: Center(child: CircularProgressIndicator()),
                    )
                    : SizedBox(
                      height: 500.h,
                      child: CardSwiper(
                        cardsCount: seggustions.length,
                        numberOfCardsDisplayed: 3,
                        onSwipe: (previousIndex, currentIndex, direction) {
                          return true;
                        },
                        cardBuilder: (context, index, px, py) {
                          final media = seggustions[index];
                          print(media);
                          return Card(
                            elevation: 6,
                            margin: const EdgeInsets.all(12),
                            child: Center(
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child:
                                        media.posterPath == null
                                            ? Container(
                                              width: 120.sp,
                                              height: 180.sp,
                                              color: Colors.grey.shade200,
                                              child: Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey.shade400,
                                                size: 50.sp,
                                              ),
                                            )
                                            : Image.network(
                                              imageBasePath + media.posterPath!,
                                            ),
                                  ),
                                  Text(
                                    media.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
