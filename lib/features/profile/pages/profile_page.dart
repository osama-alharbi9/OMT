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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authFunctionsProvider = ref.read(authProvider.notifier);
    final userLists = ref.watch(listProvider);
    List<Map<String, dynamic>> _stats = [
      {'Episodes Watched': userLists['shows']?.length},
      {'Movies Watched': 120},
      {'Total Hours': 25235},
    ];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                onPressed: () {
                  authFunctionsProvider.signOut(context);
                },
                icon: Icon(CupertinoIcons.gear_alt),
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
              child: Column(
                children: [
                  SizedBox(height: 32.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 35.r),
                        SizedBox(width: 8.w),
                        Column(
                          children: [
                            Text(
                              'John Smith',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.copyWith(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Member Since 2017',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        TextButton(onPressed: () {}, child: const Text('Edit')),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Container(
                    height: 70.h,
                    width: double.infinity,
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final stat in _stats)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  stat.values.first.toString(),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  stat.keys.first,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: authFunctionsProvider.getUserLists(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      final userLists = snapshot.data;
                      print(userLists);
                      return (userLists!.isEmpty || userLists == null)
                          ? Center(
                            child: const Text(
                              'You haven\'t added any movies or shows to your favourites or watchlist yet.\nStart exploring and save what you love!',
                            ),
                          )
                          : Column(
                            children: [
                              if ((userLists?['favourites'] as List?)
                                      ?.isNotEmpty ??
                                  false)
                                MediaSection(
                                  label: 'Favorites List',
                                  media:
                                      (userLists!['favourites'] ?? [])
                                          .map<MediaModel>(
                                            (e) => MediaModel.fromJson(e, ''),
                                          )
                                          .toList(),
                                ),
                              if ((userLists?['shows'] as List?)?.isNotEmpty ??
                                  false)
                                MediaSection(
                                  label: 'Shows',
                                  media:
                                      (userLists!['shows'] ?? [])
                                          .map<MediaModel>(
                                            (e) => MediaModel.fromJson(e, 'tv'),
                                          )
                                          .toList(),
                                ),
                              if ((userLists?['movies'] as List?)?.isNotEmpty ??
                                  false)
                                MediaSection(
                                  label: 'Movies',
                                  media:
                                      (userLists!['movies'] ?? [])
                                          .map<MediaModel>(
                                            (e) =>
                                                MediaModel.fromJson(e, 'movie'),
                                          )
                                          .toList(),
                                ),
                              if ((userLists?['watchlist'] as List?)
                                      ?.isNotEmpty ??
                                  false)
                                MediaSection(
                                  label: 'Watchlist',
                                  media:
                                      (userLists!['watchlist'] ?? [])
                                          .map<MediaModel>(
                                            (e) => MediaModel.fromJson(e, ''),
                                          )
                                          .toList()
                                          .toList(),
                                ),
                              SizedBox(height: 80.h,)
                            ],
                          );
                    },
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
