import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omt/features/discover/pages/discover_page.dart';
import 'package:omt/features/profile/pages/profile_page.dart';
import 'package:omt/features/search/search_page.dart';
import 'package:omt/features/shows/shows_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class OmtNavigator extends StatefulWidget {
  const OmtNavigator({super.key});

  @override
  State<OmtNavigator> createState() => _OmtNavigatorState();
}

class _OmtNavigatorState extends State<OmtNavigator> {
  final List<Widget> _pages = const [
    DiscoverPage(),
    SearchPage(),
    ProfilePage(),
  ];

  final List<String> iconPaths = [
    'assets/images/navigator/discover.png',
    'assets/images/navigator/search.png',
    'assets/images/navigator/profile.png',
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(decoration: NavBarDecoration(borderRadius: BorderRadius.circular(16.r)),
      margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
      padding: EdgeInsets.only(bottom: 10),
      context,
      screens: _pages,
      navBarStyle: NavBarStyle.style13,
      backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(150),
      onItemSelected: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      items: List.generate(iconPaths.length, (index) {
        return PersistentBottomNavBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Transform.scale(
              scale: 2.1.sp,
              child: Image.asset(
                iconPaths[index],
                width: 28,
                height: 28,
                color:
                    selectedIndex == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          title: "",
          iconSize: 0, // disables default icon sizing
          activeColorPrimary: Colors.transparent,
          inactiveColorPrimary: Colors.transparent,
        );
      }),
    );
  }
}
