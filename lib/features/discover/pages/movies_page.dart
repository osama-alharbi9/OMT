import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omt/core/common/helpers/helper_functions.dart';
import 'package:omt/features/discover/providers/media_provider.dart';
import 'package:omt/features/discover/widgets/movies_section.dart';

class MoviesPage extends ConsumerStatefulWidget {
  const MoviesPage({super.key});

  @override
  ConsumerState<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends ConsumerState<MoviesPage> {
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
              flexibleSpace: PageView.builder(
                itemCount: mediaFetch['trendingAll']!.take(6).length,

                itemBuilder: (context, index) {
                  final allDayTrending = mediaFetch['trendingAll']!;
                  return SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.network(
                        imageBasePath + allDayTrending[index]!.posterPath!,
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  MoviesSection(
                    media: mediaFetch['popularMovies']!,
                    label: 'Popular Movies',
                  ),
                  MoviesSection(
                    media: mediaFetch['popularTv']!,
                    label: 'Popular Shows',
                  ),
                  MoviesSection(
                    media: mediaFetch['nowPlayingMovies']!,
                    label: 'Latest Movies',
                  ),
                  MoviesSection(
                    media: mediaFetch['onTheAirTv']!,
                    label: 'Latest Shows',
                  ),
                  // MoviesSection(label: 'Latest Shows'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
