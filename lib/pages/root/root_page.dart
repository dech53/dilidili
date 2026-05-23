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
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      bottomNavigationBar: _buildGlassBottomBar(context),
      body: LazyLoadIndexedStack(
        index: _index,
        children: const [HomePage(), TrendPage(), MomentsPage(), UserPage()],
      ),
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
