import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omt/features/discover/models/media_model.dart';
import 'package:omt/features/discover/pages/all_media.dart';
import 'package:omt/features/discover/widgets/media_card.dart';

class MediaSection extends StatelessWidget {
  const MediaSection({super.key, required this.label, required this.media});

  final String label;
  final List<MediaModel?> media;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ).copyWith(top: 32.h, bottom: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (e)=>AllMedia(media: media))),
                child: Text(
                  'See All',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSecondary.withOpacity(0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: media.take(10).length,
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final item = media[index];
                if (item == null) {
                return const SizedBox.shrink();
                }
              return MediaCard(mediaItem: item,posterPath: item.posterPath!,);
            },
          ),
        ),
      ],
    );
  }
}
