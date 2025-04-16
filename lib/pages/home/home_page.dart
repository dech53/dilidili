import 'package:dilidili/pages/home/controller.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final HomeController _homeController = Get.put(HomeController());
  List videoList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _getBodyUI(),
    );
  }

  Widget _getBodyUI() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          10.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              height: ScreenUtil().screenHeight * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //问候语
                  Text(
                    "${StringUtils.getTimeGreeting()},dech53",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  //头像
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://i1.hdslb.com/bfs/face/7cd9a2b4c9ce9a99443f8a22fe4e7cc3a0c10039.jpg@120w_120h_1c.avif",
                    ),
                  ),
                ],
              ),
            ),
          ),
          15.verticalSpace,
          //搜索
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              height: ScreenUtil().screenHeight * 0.05,
              child: Row(
                children: [
                  //搜索框
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 12.w),
                      alignment: Alignment.centerLeft,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_outlined,
                            size: 25.r,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          5.horizontalSpace,
                          Text(
                            "搜索...",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.w),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_outlined,
                        size: 25.r,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //Expanded + tabbar
          //视频列表
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: CustomTabs(),
          ),
          Expanded(
            child: TabBarView(
              controller: _homeController.tabController,
              children: _homeController.tabsPageList,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTabs extends StatefulWidget {
  const CustomTabs({super.key});

  @override
  State<CustomTabs> createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabs> {
  final HomeController _homeController = Get.put(HomeController());

  void onTap(int index) {
    if (_homeController.initialIndex.value == index) {
      _homeController.tabsCtrList[index]().animateToTop();
    }
    _homeController.initialIndex.value = index;
    _homeController.tabController.index = index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.only(top: 8),
      child: Obx(
        () => ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          scrollDirection: Axis.horizontal,
          itemCount: _homeController.tabs.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 10);
          },
          itemBuilder: (BuildContext context, int index) {
            String label = _homeController.tabs[index]['label'];
            return Obx(
              () => CustomChip(
                onTap: () => onTap(index),
                label: label,
                selected: index == _homeController.initialIndex.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomChip extends StatelessWidget {
  final Function onTap;
  final String label;
  final bool selected;
  const CustomChip({
    super.key,
    required this.onTap,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorTheme = Theme.of(context).colorScheme;
    final Color secondaryContainer = colorTheme.secondaryContainer;
    final Color onPrimary = colorTheme.onPrimary;
    final Color primary = colorTheme.primary;
    final TextStyle chipTextStyle = selected
        ? TextStyle(fontSize: 13, color: onPrimary)
        : TextStyle(fontSize: 13, color: colorTheme.onSecondaryContainer);
    const VisualDensity visualDensity =
        VisualDensity(horizontal: -4.0, vertical: -2.0);
    return InputChip(
      side: BorderSide.none,
      backgroundColor: secondaryContainer,
      color: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected) ||
            states.contains(WidgetState.hovered)) {
          return primary;
        }
        return colorTheme.secondaryContainer;
      }),
      padding: const EdgeInsets.fromLTRB(6, 1, 6, 1),
      label: Text(label, style: chipTextStyle),
      onPressed: () => onTap(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      selected: selected,
      showCheckmark: false,
      visualDensity: visualDensity,
    );
  }
}
