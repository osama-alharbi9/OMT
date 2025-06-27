import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omt/core/common/helpers/helper_functions.dart';
import 'package:omt/features/discover/pages/media_details.dart';
import 'package:omt/features/discover/providers/media_provider.dart';
import 'package:omt/features/discover/widgets/media_section.dart';

class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({super.key});

  @override
  ConsumerState<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(mediaProvider.notifier).fetchAllEndpoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaFetch = ref.watch(mediaProvider);
    final trending = mediaFetch['trendingAll'];
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(mediaProvider.notifier).fetchAllEndpoints();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              stretch: true,
              expandedHeight: 430.h,
              flexibleSpace:trending==null||trending.isEmpty?Center(child: const CircularProgressIndicator()): PageView(
                children:
                    mediaFetch['trendingAll']!
                        .map(
                          (media) => GestureDetector(onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (e)=>MediaDetails(media: media)));
                          },
                            child: SizedBox(
                              height: 386.h,
                              child: FittedBox(fit: BoxFit.cover,
                                child: Image.network(
                                  imageBasePath + media!.posterPath!,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            if (trending != null)
            SliverToBoxAdapter(
              child: Column(
                children: [
                  MediaSection(
                    media: mediaFetch['popularMovies']!,
                    label: 'Popular Movies',
                  ),
                  MediaSection(
                    media: mediaFetch['popularTv']!,
                    label: 'Popular Shows',
                  ),
                  MediaSection(
                    media: mediaFetch['nowPlayingMovies']!,
                    label: 'Latest Movies',
                  ),
                  MediaSection(
                    media: mediaFetch['onTheAirTv']!,
                    label: 'Latest Shows',
                  ),
                  // MediaSection(label: 'Latest Shows'),
                  SizedBox(height: 80.h,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
