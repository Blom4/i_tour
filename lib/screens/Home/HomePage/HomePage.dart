import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:i_tour/screens/Home/Profile/Profile.dart';
import 'package:i_tour/screens/Home/TrackingList/Trackinglist.dart';
import 'package:i_tour/screens/Home/TransportCabs/TransportCabs.dart';
import 'package:i_tour/screens/Home/WeatherForcast/WeatherForcast.dart';
import 'package:i_tour/screens/Maps/Maps.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_final_fields
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
     List<Widget> _buildScreens() {
        return [
          const TrackingList(),
          const Maps(),
          const WeatherForecast(),
          const TransportCabs(),
          const Emergency(),
          const Profile()
        ];
    }
 List<PersistentBottomNavBarItem> _navBarsItems() {
        return [
            PersistentBottomNavBarItem(
                icon: const Icon(CupertinoIcons.home),
                title: ("Home"),
                activeColorPrimary: const Color.fromARGB(255, 66, 158, 211),
                inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
                icon: const Icon(CupertinoIcons.map),
                title: ("Map"),
                activeColorPrimary: const Color.fromARGB(255, 68, 204, 214),
                inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
                icon: const Icon(CupertinoIcons.cloud_rain),
                title: ("Weather"),
                activeColorPrimary: const Color.fromARGB(255, 88, 40, 128),
                inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
                icon: const Icon(CupertinoIcons.train_style_one),
                title: ("Transport"),
                activeColorPrimary: const Color.fromARGB(255, 24, 110, 39),
                inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
                icon: const Icon(CupertinoIcons.building_2_fill),
                title: ("Emergency"),
                activeColorPrimary: const Color.fromARGB(255, 24, 110, 39),
                inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
                icon: const Icon(CupertinoIcons.profile_circled),
                title: ("Profile"),
                activeColorPrimary: const Color.fromARGB(255, 216, 138, 20),
                inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
        ];
    }
}
