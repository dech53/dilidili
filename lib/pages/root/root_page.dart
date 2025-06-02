import 'package:dilidili/pages/home/view.dart';
import 'package:dilidili/pages/moments/moments_page.dart';
import 'package:dilidili/pages/trend/view.dart';
import 'package:dilidili/pages/user/view.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _index = 2;

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
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: _getBottomNavigator(context),
      body: LazyLoadIndexedStack(
        index: _index,
        children: const [HomePage(), TrendPage(), MomentsPage(), UserPage()],
      ),
    );
  }

  Widget _getBottomNavigator(BuildContext context) {
    return SalomonBottomBar(
      currentIndex: _index,
      onTap: (index) {
        setState(() {
          _index = index;
        });
      },
      items: List.generate(
        rootApp.length,
        (index) {
          return SalomonBottomBarItem(
            selectedColor: Theme.of(context).colorScheme.onSurface,
            unselectedColor: Theme.of(context).colorScheme.onSurface,
            icon: Icon(rootApp[index]
                [(_index == index) ? 'SelectedIcon' : 'unSelectedIcon']),
            title: Text(rootApp[index]['text']),
          );
        },
      ),
    );
  }
}
