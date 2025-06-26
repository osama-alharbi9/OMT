import 'package:flutter/material.dart';
import 'package:omt/features/discover/models/media_item.dart';
import 'package:omt/features/discover/widgets/movie_card.dart';

class AllMedia extends StatelessWidget {
  const AllMedia({super.key, required this.media});
  final List<MediaItem?> media;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: media.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),
        itemBuilder: (context, index) {
          return MediaCard(
            mediaItem: media[index]!,
            mediaName: media[index]!.title,
            posterPath: media[index]!.posterPath!,
          );
        },
      ),
    );
  }
}
