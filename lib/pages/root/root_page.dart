import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/pages/home/view.dart';
import 'package:dilidili/pages/moments/view.dart';
import 'package:dilidili/pages/root/controller.dart';
import 'package:dilidili/pages/trend/view.dart';
import 'package:dilidili/pages/user/view.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  static const String _homeIcon = 'assets/images/tab/home.png';
  static const String _homeOutlinedIcon = 'assets/images/tab/home_outlined.png';
  static const String _trendingUpIcon = 'assets/images/tab/trending_up.png';
  static const String _trendingUpOutlinedIcon =
      'assets/images/tab/trending_up_outlined.png';
  static const String _motionPhotosOnIcon =
      'assets/images/tab/motion_photos_on.png';
  static const String _motionPhotosOnOutlinedIcon =
      'assets/images/tab/motion_photos_on_outlined.png';
  static const String _personIcon = 'assets/images/tab/person.png';
  static const String _personOutlineIcon =
      'assets/images/tab/person_outline.png';
  static const String _searchRoundedIcon =
      'assets/images/tab/search_rounded.png';

  @override
  void dispose() async {
    await SPStorage.close();
    super.dispose();
  }

  final RootController _rootController = Get.put(RootController());
  int _index = 0;

  List rootApp = [
    {
      "SelectedIcon": Icons.home,
      "unSelectedIcon": Icons.home_outlined,
      "text": "首页",
    },
    {
      "SelectedIcon": Icons.trending_up,
      "unSelectedIcon": Icons.trending_up_outlined,
      "text": "排行榜",
    },
    {
      "SelectedIcon": Icons.motion_photos_on,
      "unSelectedIcon": Icons.motion_photos_on_outlined,
      "text": "动态",
    },
    {
      "SelectedIcon": Icons.person,
      "unSelectedIcon": Icons.person_outline,
      "text": "我的",
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (!PlatformInfo.isIOS26OrHigher()) {
      return Scaffold(
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        bottomNavigationBar: _buildGlassBottomBar(context),
        body: _buildBody(),
      );
    }

    return Obx(
      () => AdaptiveScaffold(
        bottomNavigationBar: _buildAdaptiveBottomBar(context),
        minimizeBehavior: TabBarMinimizeBehavior.never,
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return LazyLoadIndexedStack(
      index: _index,
      children: const [HomePage(), TrendPage(), MomentsPage(), UserPage()],
    );
  }

  Widget _buildGlassBottomBar(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color selectedColor = colorScheme.primary;
    final Color unselectedColor = colorScheme.onSurface.withValues(alpha: 0.68);

    return Obx(
      () => GlassBottomBar(
        selectedIndex: _index,
        onTabSelected: (value) => setState(() {
          _index = value;
        }),
        selectedIconColor: selectedColor,
        unselectedIconColor: unselectedColor,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.32),
        indicatorSettings: const LiquidGlassSettings(
          glassColor: Colors.transparent,
          lightIntensity: 0,
          chromaticAberration: 0,
          blur: 0,
        ),
        glowOpacity: 0,
        quality: GlassQuality.standard,
        maskingQuality: MaskingQuality.high,
        horizontalPadding: 18,
        verticalPadding: 14,
        barHeight: 62,
        spacing: 12,
        extraButton: GlassBottomBarExtraButton(
          icon: const Icon(Icons.search_rounded),
          label: '搜索',
          iconColor: colorScheme.onSurface,
          size: 62,
          onTap: () => Get.toNamed('/search'),
        ),
        textStyle: TextStyle(
          color: unselectedColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        tabs: rootApp.map((e) {
          final bool isUserTab = e['text'] == '我的';
          final bool showAvatar = _rootController.userLogin.value && isUserTab;

          return GlassBottomBarTab(
            label: e['text'],
            icon: showAvatar
                ? NetworkImgLayer(
                    width: 25,
                    height: 25,
                    type: 'avatar',
                    src: _rootController.userInfo.face,
                  )
                : Icon(e['unSelectedIcon']),
            activeIcon: showAvatar
                ? NetworkImgLayer(
                    width: 25,
                    height: 25,
                    type: 'avatar',
                    src: _rootController.userInfo.face,
                  )
                : Icon(e['SelectedIcon']),
            glowColor: null,
          );
        }).toList(),
      ),
    );
  }

  AdaptiveBottomNavigationBar _buildAdaptiveBottomBar(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color selectedColor = colorScheme.primary;
    final Color unselectedColor = colorScheme.onSurface.withValues(alpha: 0.68);

    return AdaptiveBottomNavigationBar(
      items: _adaptiveNavigationItems(),
      selectedIndex: _pageIndexToNavigationIndex(_index),
      onTap: _onNavigationTap,
      selectedItemColor: selectedColor,
      unselectedItemColor: unselectedColor,
      bottomNavigationBar: _buildMaterialNavigationBar(
        context,
        selectedColor,
        unselectedColor,
      ),
    );
  }

  List<AdaptiveNavigationDestination> _adaptiveNavigationItems() {
    final Object userIcon = _userNavigationIcon(
      fallbackIcon: _personOutlineIcon,
    );
    final Object selectedUserIcon = _userNavigationIcon(
      fallbackIcon: _personIcon,
    );

    return [
      const AdaptiveNavigationDestination(
        icon: AssetImage(_homeOutlinedIcon),
        selectedIcon: AssetImage(_homeIcon),
        label: '首页',
      ),
      const AdaptiveNavigationDestination(
        icon: AssetImage(_trendingUpOutlinedIcon),
        selectedIcon: AssetImage(_trendingUpIcon),
        label: '排行榜',
        addSpacerAfter: true,
      ),
      const AdaptiveNavigationDestination(
        icon: AssetImage(_searchRoundedIcon),
        label: '搜索',
        isSearch: true,
      ),
      const AdaptiveNavigationDestination(
        icon: AssetImage(_motionPhotosOnOutlinedIcon),
        selectedIcon: AssetImage(_motionPhotosOnIcon),
        label: '动态',
      ),
      AdaptiveNavigationDestination(
        icon: userIcon,
        selectedIcon: selectedUserIcon,
        label: '我的',
      ),
    ];
  }

  Object _userNavigationIcon({required String fallbackIcon}) {
    if (!_rootController.userLogin.value) return AssetImage(fallbackIcon);

    final String face = _rootController.userInfo.face;
    if (face.isEmpty) return AssetImage(fallbackIcon);

    return NetworkImage(face);
  }

  Widget _buildMaterialNavigationBar(
    BuildContext context,
    Color selectedColor,
    Color unselectedColor,
  ) {
    return NavigationBar(
      selectedIndex: _pageIndexToNavigationIndex(_index),
      onDestinationSelected: _onNavigationTap,
      indicatorColor: selectedColor.withValues(alpha: 0.18),
      destinations: [
        _materialAssetDestination(
          icon: _homeOutlinedIcon,
          selectedIcon: _homeIcon,
          label: '首页',
        ),
        _materialAssetDestination(
          icon: _trendingUpOutlinedIcon,
          selectedIcon: _trendingUpIcon,
          label: '排行榜',
        ),
        const NavigationDestination(
          icon: ImageIcon(AssetImage(_searchRoundedIcon)),
          selectedIcon: ImageIcon(AssetImage(_searchRoundedIcon)),
          label: '搜索',
        ),
        _materialAssetDestination(
          icon: _motionPhotosOnOutlinedIcon,
          selectedIcon: _motionPhotosOnIcon,
          label: '动态',
        ),
        NavigationDestination(
          icon: _materialUserIcon(
            fallbackIcon: Icons.person_outline,
            color: unselectedColor,
          ),
          selectedIcon: _materialUserIcon(
            fallbackIcon: Icons.person,
            color: selectedColor,
          ),
          label: '我的',
        ),
      ],
    );
  }

  NavigationDestination _materialAssetDestination({
    required String icon,
    required String selectedIcon,
    required String label,
  }) {
    return NavigationDestination(
      icon: ImageIcon(AssetImage(icon)),
      selectedIcon: ImageIcon(AssetImage(selectedIcon)),
      label: label,
    );
  }

  Widget _materialUserIcon({
    required IconData fallbackIcon,
    required Color color,
  }) {
    if (!_rootController.userLogin.value) {
      return ImageIcon(
        AssetImage(
          fallbackIcon == Icons.person ? _personIcon : _personOutlineIcon,
        ),
      );
    }

    final String face = _rootController.userInfo.face;
    if (face.isEmpty) {
      return ImageIcon(
        AssetImage(
          fallbackIcon == Icons.person ? _personIcon : _personOutlineIcon,
        ),
      );
    }

    return SizedBox(
      width: 25,
      height: 25,
      child: ClipOval(
        child: Image.network(
          face,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(fallbackIcon, color: color),
        ),
      ),
    );
  }

  int _pageIndexToNavigationIndex(int pageIndex) {
    return pageIndex >= 2 ? pageIndex + 1 : pageIndex;
  }

  void _onNavigationTap(int navigationIndex) {
    if (navigationIndex == 2) {
      Get.toNamed('/search');
      return;
    }

    final int pageIndex =
        navigationIndex > 2 ? navigationIndex - 1 : navigationIndex;
    setState(() {
      _index = pageIndex;
    });
  }

  // Widget _getBottomNavigator(BuildContext context) {
  // return SalomonBottomBar(
  //   currentIndex: _index,
  //   onTap: (index) {
  //     setState(() {
  //       _index = index;
  //     });
  //   },
  //   items: List.generate(
  //     rootApp.length,
  //     (index) {
  //       return SalomonBottomBarItem(
  //         selectedColor: Theme.of(context).colorScheme.onSurface,
  //         unselectedColor: Theme.of(context).colorScheme.onSurface,
  //         icon: Icon(rootApp[index]['unSelectedIcon']),
  //         title: Text(rootApp[index]['text']),
  //         activeIcon: Icon(rootApp[index]['SelectedIcon']),
  //       );
  //     },
  //   ),
  // );

  // return BottomNavigationBar(
  //   currentIndex: _index,
  //   iconSize: 16,
  //   selectedFontSize: 12,
  //   unselectedFontSize: 12,
  //   type: BottomNavigationBarType.fixed,
  //   onTap: (index) {
  //     setState(() {
  //       _index = index;
  //     });
  //   },
  //   items: List.generate(
  //     rootApp.length,
  //     (index) {
  //       return BottomNavigationBarItem(
  //         icon: Icon(rootApp[index]['unSelectedIcon']),
  //         activeIcon: Icon(rootApp[index]['SelectedIcon']),
  //         label: rootApp[index]['text'],
  //       );
  //     },
  //   ),
  // );
  // }
}
