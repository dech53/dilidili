import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/pages/home/view.dart';
import 'package:dilidili/pages/moments/view.dart';
import 'package:dilidili/pages/root/controller.dart';
import 'package:dilidili/pages/trend/view.dart';
import 'package:dilidili/pages/user/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
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
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) => setState(() {
          _index = value;
        }),
        selectedIndex: _index,
        destinations: <Widget>[
          ...rootApp.map(
            (e) {
              return NavigationDestination(
                icon: (_rootController.userLogin.value && e['text'] == '我的')
                    ? NetworkImgLayer(
                        width: 25,
                        height: 25,
                        type: 'avatar',
                        src: _rootController.userInfo.face,
                      )
                    : Icon(e['unSelectedIcon']),
                label: e['text'],
                selectedIcon:
                    (_rootController.userLogin.value && e['text'] == '我的')
                        ? NetworkImgLayer(
                            width: 25,
                            height: 25,
                            type: 'avatar',
                            src: _rootController.userInfo.face,
                          )
                        : Icon(e['SelectedIcon']),
              );
            },
          )
        ],
      ),
      body: LazyLoadIndexedStack(
        index: _index,
        children: const [HomePage(), TrendPage(), MomentsPage(), UserPage()],
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
