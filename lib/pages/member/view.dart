import 'dart:async';

import 'package:dilidili/common/skeleton/video_card_h.dart';
import 'package:dilidili/common/unsupported.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/common/widgets/no_data.dart';
import 'package:dilidili/model/member_tab_type.dart';
import 'package:dilidili/pages/member_fav/view.dart';
import 'package:dilidili/pages/member/controller.dart';
import 'package:dilidili/pages/member_home/view.dart';
import 'package:dilidili/pages/member_moment/view.dart';
import 'package:dilidili/pages/member_pgc/view.dart';
import 'package:dilidili/pages/member_post/view.dart';
import 'package:dilidili/pages/member/widgets/profile.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  late String heroTag;

  late MemberController _memberController;
  late Future _futureBuilderFuture;
  final ScrollController _extendNestCtr = ScrollController();
  late double statusBarHeight;
  final StreamController<bool> appbarStream =
      StreamController<bool>.broadcast();
  bool _isAppBarCollapsed = false;
  late int mid;
  @override
  void initState() {
    super.initState();
    statusBarHeight = SPStorage.statusBarHeight;
    mid = int.parse(Get.arguments['mid']!);
    heroTag = Get.arguments['heroTag'] ?? StringUtils.makeHeroTag(mid);
    _memberController = Get.put(MemberController(), tag: heroTag);
    _futureBuilderFuture = _memberController.getInfo();
    _extendNestCtr.addListener(_handleOuterScroll);
  }

  @override
  void dispose() {
    _extendNestCtr.removeListener(_handleOuterScroll);
    _extendNestCtr.dispose();
    appbarStream.close();
    super.dispose();
  }

  void _handleOuterScroll() {
    final bool collapsed = _extendNestCtr.position.pixels > 120;
    if (_isAppBarCollapsed == collapsed) return;
    _isAppBarCollapsed = collapsed;
    appbarStream.add(collapsed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: ExtendedNestedScrollView(
          controller: _extendNestCtr,
          headerSliverBuilder:
              (BuildContext context2, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: profileWidget(),
              ),
            ];
          },
          pinnedHeaderSliverHeightBuilder: () {
            return statusBarHeight + kToolbarHeight;
          },
          onlyOneScrollInBody: true,
          body: Obx(
            () {
              if (_memberController.isSpaceLoading.value) {
                return CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, index) => const VideoCardHSkeleton(),
                        childCount: 5,
                      ),
                    ),
                  ],
                );
              }
              final int tabCount = _memberController.tabs.length;
              final TabController? tabController =
                  _memberController.tabController;
              if (tabController == null || tabCount == 0) {
                return const CustomScrollView(
                  slivers: [
                    NoData(),
                  ],
                );
              }
              return Column(
                children: [
                  if (tabCount > 1)
                    _MemberTabBar(
                      controller: tabController,
                      tabs: _memberController.tabWidgets,
                      onTap: _memberController.onTapTab,
                    ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: _memberController.tabs
                          .map(_buildTabPage)
                          .toList(growable: false),
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }

  Widget _buildTabPage(MemberTabConfig item) {
    final String? param = item['param'] as String?;
    final String title = item['label'] as String? ?? '';
    return switch (param) {
      'home' => MemberHomePage(
          mid: mid,
          heroTag: heroTag,
        ),
      'dynamic' => MemberMomentPage(mid: mid),
      'contribute' => MemberPostPage(mid: mid),
      'favorite' => FavoritePage(mid: mid),
      'bangumi' => MemberBangumi(
          mid: mid,
          heroTag: heroTag,
        ),
      _ => UnsupportedMemberTabPage(title: title, param: param),
    };
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: StreamBuilder<bool>(
        stream: appbarStream.stream.distinct(),
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          final bool collapsed = snapshot.data ?? false;
          final ColorScheme colorScheme = Theme.of(context).colorScheme;
          final bool isDark = colorScheme.brightness == Brightness.dark;
          return AppBar(
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  isDark ? Brightness.light : Brightness.dark,
              statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
              systemStatusBarContrastEnforced: false,
            ),
            elevation: collapsed ? 0.5 : 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: colorScheme.onSurface,
            flexibleSpace: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              color: collapsed ? colorScheme.surface : Colors.transparent,
            ),
            title: AnimatedOpacity(
              opacity: collapsed ? 1 : 0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 220),
              child: Row(
                children: [
                  Obx(
                    () => NetworkImgLayer(
                      width: 35,
                      height: 35,
                      type: 'avatar',
                      src: _memberController.spaceData.value?.card?.face ??
                          _memberController.face.value,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => Text(
                      _memberController.spaceData.value?.card?.name ??
                          _memberController.memberInfo.value.name ??
                          '',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search_outlined),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  if (_memberController.ownerMid != _memberController.mid) ...[
                    PopupMenuItem(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.block, size: 19),
                          const SizedBox(width: 10),
                          Text(_memberController.attribute.value != 128
                              ? '加入黑名单'
                              : '移除黑名单'),
                        ],
                      ),
                    )
                  ],
                  PopupMenuItem(
                    onTap: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.share_outlined, size: 19),
                        const SizedBox(width: 10),
                        Text(_memberController.ownerMid != _memberController.mid
                            ? '分享UP主'
                            : '分享我的主页'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
            ],
          );
        },
      ),
    );
  }

  Widget profileWidget() {
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final Map? data = snapshot.data;
          if (data != null && data['status']) {
            return ProfilePanel(ctr: _memberController);
          }
          return const SizedBox.shrink();
        }
        return ProfilePanel(ctr: _memberController, loadingStatus: true);
      },
    );
  }
}

class _MemberTabBar extends StatelessWidget {
  const _MemberTabBar({
    required this.controller,
    required this.tabs,
    required this.onTap,
  });

  final TabController controller;
  final List<Tab> tabs;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    if (tabs.length < 2) return const SizedBox.shrink();

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.18),
            width: 0.5,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        tabs: tabs,
        onTap: onTap,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.62),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        dividerColor: Colors.transparent,
        splashBorderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
