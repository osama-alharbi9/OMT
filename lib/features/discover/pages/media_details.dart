import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omt/core/common/helpers/helper_functions.dart';
import 'package:omt/features/discover/models/media_item.dart';

class MediaDetails extends StatefulWidget {
  const MediaDetails({super.key, required this.media});
  final MediaItem media;

  @override
  State<MediaDetails> createState() => _MediaDetailsState();
}

class _MediaDetailsState extends State<MediaDetails> {
  @override
  Widget build(BuildContext context) {
    String getRatingEmoji(double voteAverage) {
      final rounded = voteAverage.round();
      switch (rounded) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
          return '💩';
        case 5:
          return '😕';
        case 6:
          return '😐';
        case 7:
          return '🙂';
        case 8:
          return '😍';
        case 9:
          return '🤯';
        case 10:
          return '👑';
        default:
          return '🤔';
      }
    }

    final String emoji = getRatingEmoji(widget.media.voteAverage);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            expandedHeight: 386.h,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(tag: widget.media.uid!,
                child: Image.network(
                  imageBasePath + widget.media.posterPath!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 32.h),
                    child: Text(
                      widget.media.title,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(widget.media.releaseDate),
                  SizedBox(height: 16.h),
                  Text(widget.media.overview),
                  SizedBox(height: 16.h),
                  Text(
                    'Tracking & Rating',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.media.voteAverage.toStringAsFixed(1)}$emoji',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(width: 8.w),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.sp),
                              color: Theme.of(
                                context,
                              ).colorScheme.secondary.withOpacity(0.1),
                            ),
                            height: 60.sp,
                            width: 60.sp,
                            child: Icon(Icons.remove_red_eye, size: 40.sp),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.sp),
                              color: Theme.of(
                                context,
                              ).colorScheme.secondary.withOpacity(0.1),
                            ),
                            height: 60.sp,
                            width: 60.sp,
                            child: Icon(CupertinoIcons.heart, size: 40.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
