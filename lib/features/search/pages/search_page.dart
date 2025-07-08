import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omt/core/common/helpers/helper_functions.dart';
import 'package:omt/features/discover/pages/media_details.dart';
import 'package:omt/features/search/providers/search_provider.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(searchProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 48.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search for movies or shows',
                      ),
                      onChanged: (query) {
                        ref.read(searchProvider.notifier).search(query);
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    width: 50.sp,
                    height: 50.sp,
                    child: Padding(
                      padding: EdgeInsets.all(5.sp),
                      child: SvgPicture.asset(
                        'assets/images/Logo.svg',
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: searchResults.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('error: $e')),
              data: (results) {
                if (results.isEmpty) {
                  return const Center(child: Text('no result'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final media = results[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: GestureDetector(onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (e)=>MediaDetails(media: media)));
                      },
                        child: ListTile(
                          title: Text(media.title),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: media.posterPath != null
                                ? Hero(tag: media.uid!,
                                  child: Image.network(
                                      imageBasePath + media.posterPath!,
                                      width: 60.w,
                                      fit: BoxFit.cover,
                                    ),
                                )
                                : const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}