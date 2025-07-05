import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omt/features/auth/providers/auth_provider.dart';
import 'package:omt/features/discover/models/media_model.dart';
import 'package:omt/features/discover/providers/list_provider.dart'; 
import 'package:omt/features/discover/widgets/media_section.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  List<Map<String, dynamic>> _stats(Map<String, dynamic> lists) {
    return [
      {'Shows Watched': (lists['shows'] as List?)?.length ?? 0},
      {'Movies Watched': (lists['movies'] as List?)?.length ?? 0},
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authFunctionsProvider = ref.read(authProvider.notifier);
    final userListsAsync = ref.watch(userListsProvider); 

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                onPressed: () => authFunctionsProvider.signOut(context),
                icon: const Icon(CupertinoIcons.gear_alt),
              ),
            ],
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Profile',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                    ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: userListsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('error: $e')),
                data: (userLists) {
                  final stats = _stats(userLists);

                  return Column(
                    children: [
                      SizedBox(height: 32.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            CircleAvatar(radius: 35.r),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'John Smith',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  'Member Since 2017',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300,
                                      ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            TextButton(onPressed: () {}, child: const Text('Edit')),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Stats
                      Container(
                        height: 70.h,
                        width: double.infinity,
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: stats
                              .map(
                                (stat) => Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        stat.values.first.toString(),
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.sp,
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                      ),
                                      Text(
                                        stat.keys.first,
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w300,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),

                      // Lists
                      if (userLists.isEmpty)
                        const Center(
                          child: Text(
                            'You haven\'t added any movies or shows to your favourites or watchlist yet.\nStart exploring and save what you love!',
                          ),
                        )
                      else
                        Column(
                          children: [
                            if ((userLists['favourites'] as List?)?.isNotEmpty ?? false)
                              MediaSection(
                                label: 'Favorites List',
                                media: (userLists['favourites'] ?? [])
                                    .map<MediaModel>((e) => MediaModel.fromJson(e, ''))
                                    .toList(),
                              ),
                            if ((userLists['shows'] as List?)?.isNotEmpty ?? false)
                              MediaSection(
                                label: 'Shows',
                                media: (userLists['shows'] ?? [])
                                    .map<MediaModel>((e) => MediaModel.fromJson(e, 'tv'))
                                    .toList(),
                              ),
                            if ((userLists['movies'] as List?)?.isNotEmpty ?? false)
                              MediaSection(
                                label: 'Movies',
                                media: (userLists['movies'] ?? [])
                                    .map<MediaModel>((e) => MediaModel.fromJson(e, 'movie'))
                                    .toList(),
                              ),
                            if ((userLists['watchlist'] as List?)?.isNotEmpty ?? false)
                              MediaSection(
                                label: 'Watchlist',
                                media: (userLists['watchlist'] ?? [])
                                    .map<MediaModel>((e) => MediaModel.fromJson(e, ''))
                                    .toList(),
                              ),
                            SizedBox(height: 80.h),
                          ],
                        ),
                    ],
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