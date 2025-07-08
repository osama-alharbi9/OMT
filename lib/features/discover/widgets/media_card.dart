import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omt/core/common/helpers/helper_functions.dart';
import 'package:omt/features/discover/models/media_model.dart';
import 'package:omt/features/discover/pages/media_details.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({
    super.key,
    required this.mediaItem,
    required this.posterPath,
  });
  final MediaModel mediaItem;
  final String posterPath;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (e)=>MediaDetails(media: mediaItem,)));
    },
      child: Hero(tag: mediaItem.uid!,
        child: Container(
          height: 171,
          width: 114,
          color: Colors.grey,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.network(
              imageBasePath + posterPath,
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
                    color: Theme.of(context).colorScheme.surface,
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
          ),
        ),
      ),
    );
  }
}
