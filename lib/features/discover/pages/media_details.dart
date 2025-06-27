import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omt/core/common/helpers/helper_functions.dart';
import 'package:omt/features/discover/models/media_model.dart';
import 'package:omt/features/discover/providers/cast_provider.dart';
import 'package:omt/features/discover/providers/media_provider.dart';

class MediaDetails extends ConsumerStatefulWidget {
  const MediaDetails({super.key, required this.media});
  final MediaModel media;

  @override
  ConsumerState<MediaDetails> createState() => _MediaDetailsState();
}

class _MediaDetailsState extends ConsumerState<MediaDetails> {
  @override
  void initState() {
    Future.microtask(() {
      final castFunctionsProvider = ref
          .read(castProvider.notifier)
          .fetchCast(widget.media.id, widget.media.mediaType);
    });
    super.initState();
  }

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
    Widget longText() {
      if (widget.media.overview.characters.length >= 150) {
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(text: widget.media.overview.substring(0, 150) + '... '),
              TextSpan(
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        showModalBottomSheet(
                          useRootNavigator: true,
                          context: context,
                          builder:
                              (e) => Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 32.h,
                                  horizontal: 16.w,
                                ),
                                child: SizedBox(
                                  height: 300,
                                  child: Text(
                                    widget.media.overview,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                        );
                      },
                text: 'See more!',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      } else {
        return Text(widget.media.overview);
      }
    }

    final castFetch = ref.watch(castProvider)[widget.media.id];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            expandedHeight: 386.h,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.media.uid!,
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
              child: Expanded(
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
                    longText(),
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
                    SizedBox(height: 16.h),
                    Text(
                      'Cast',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (castFetch == null) ...[
                  const SizedBox(height: 16),
                  const Text('Loading cast...'),
                ] else if (castFetch.isEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('No cast available.'),
                ] else
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final cast in castFetch)
                          Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: SizedBox(
                              height: 152.h,
                              width: 114.w,
                              child: Stack(
                                children: [
                                  Image.network(
                                    imageBasePath + cast.profilePath!,
                                    loadingBuilder: (
                                      BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress,
                                    ) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Container(
                                          width: 120.sp,
                                          height: 180.sp,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                        );
                                      }
                                    },
                                    errorBuilder: (
                                      BuildContext context,
                                      Object error,
                                      StackTrace? stackTrace,
                                    ) {
                                      return Container(
                                        width: 120.sp,
                                        height: 180.sp,
                                        color: Colors.grey.shade200,
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey.shade400,
                                          size: 50.sp,
                                        ),
                                      );
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(cast.name!),
                                        Text(cast.character!),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                SizedBox(height: 80.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
