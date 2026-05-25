import 'dart:async';

import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/member_tab_type.dart';
import 'package:dilidili/pages/member/controller.dart';
import 'package:dilidili/pages/member/widgets/profile.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage>
    with SingleTickerProviderStateMixin {
  late String heroTag;

  late MemberController _memberController;
  late Future _futureBuilderFuture;
  late TabController _tabController;
  int _selectedTabIndex = 1;
  final ScrollController _extendNestCtr = ScrollController();
  late double statusBarHeight;
  final StreamController<bool> appbarStream =
      StreamController<bool>.broadcast();
  late int mid;
  @override
  void initState() {
    super.initState();
    statusBarHeight = SPStorage.statusBarHeight;
    mid = int.parse(Get.arguments['mid']!);
    heroTag = Get.arguments['heroTag'] ?? StringUtils.makeHeroTag(mid);
    _memberController = Get.put(MemberController(), tag: mid.toString());
    _futureBuilderFuture = _memberController.getInfo();
    _tabController = TabController(
      length: memberTabs.length,
      vsync: this,
      initialIndex: 1,
    );
    _tabController.addListener(_handleTabChanged);
    _extendNestCtr.addListener(
      () {
        final double offset = _extendNestCtr.position.pixels;
        if (offset > 100) {
          appbarStream.add(true);
        } else {
          appbarStream.add(false);
        }
      },
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    _extendNestCtr.removeListener(() {});
    appbarStream.close();
    super.dispose();
  }

  void _handleTabChanged() {
    if (_selectedTabIndex == _tabController.index || !mounted) return;
    setState(() {
      _selectedTabIndex = _tabController.index;
    });
  }

  void _selectTab(int index) {
    if (_selectedTabIndex == index) return;
    setState(() {
      _selectedTabIndex = index;
    });
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: StreamBuilder(
          stream: appbarStream.stream.distinct(),
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return AnimatedOpacity(
              opacity: snapshot.data ? 1 : 0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 500),
              child: Row(
                children: [
                  Row(
                    children: [
                      Obx(
                        () => NetworkImgLayer(
                          width: 35,
                          height: 35,
                          type: 'avatar',
                          src: _memberController.face.value,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Obx(
                        () => Text(
                          _memberController.memberInfo.value.name ?? '',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
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
      ),
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
            return 0;
          },
          onlyOneScrollInBody: true,
          body: Column(
            children: [
              _MemberGlassTabSelector(
                selectedIndex: _selectedTabIndex,
                tabs: _memberController.tabs
                    .map<String>((e) => e['label'] as String)
                    .toList(),
                onSelected: _selectTab,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: memberTabs.map(
                    (e) {
                      return e['page'] as Widget;
                    },
                  ).toList(),
                ),
              ),
            ],
          )),
    );
  }

  Widget profileWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, bottom: 10),
      child: FutureBuilder(
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map? data = snapshot.data;
            if (data != null && data['status']) {
              return Obx(
                () => Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfilePanel(ctr: _memberController),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Flexible(
                                child: Text(
                              _memberController.memberInfo.value.name!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _memberController.memberInfo.value.vip!
                                            .nicknameColor !=
                                        ''
                                    ? Color(int.parse(
                                        "0xFF${_memberController.memberInfo.value.vip!.nicknameColor!.replaceAll('#', '')}"))
                                    : Colors.black,
                              ),
                            )),
                            const SizedBox(width: 2),
                            if (_memberController.memberInfo.value.sex == '女')
                              const Icon(
                                FontAwesomeIcons.venus,
                                size: 14,
                                color: Colors.pink,
                              ),
                            if (_memberController.memberInfo.value.sex == '男')
                              const Icon(
                                FontAwesomeIcons.mars,
                                size: 14,
                                color: Colors.blue,
                              ),
                            const SizedBox(width: 4),
                            Image.asset(
                              'assets/images/lv/lv${_memberController.memberInfo.value.level}.png',
                              height: 11,
                            ),
                            const SizedBox(width: 6),
                            if (_memberController
                                        .memberInfo.value.vip!.status ==
                                    1 &&
                                _memberController.memberInfo.value.vip!.label!
                                        .imgLabelUriHans !=
                                    '') ...[
                              Image.network(
                                _memberController.memberInfo.value.vip!.label!
                                    .imgLabelUriHans!,
                                height: 20,
                              ),
                            ] else if (_memberController
                                        .memberInfo.value.vip!.status ==
                                    1 &&
                                _memberController.memberInfo.value.vip!.label!
                                        .imgLabelUriHansStatic !=
                                    '') ...[
                              Image.network(
                                _memberController.memberInfo.value.vip!.label!
                                    .imgLabelUriHansStatic!,
                                height: 20,
                              ),
                            ]
                          ],
                        ),
                        if (_memberController
                                .memberInfo.value.official!.title !=
                            '') ...[
                          const SizedBox(height: 6),
                          Text.rich(
                            maxLines: 2,
                            TextSpan(
                              text: _memberController
                                          .memberInfo.value.official!.role ==
                                      1
                                  ? '个人认证：'
                                  : '企业认证：',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              children: [
                                TextSpan(
                                  text: _memberController
                                      .memberInfo.value.official!.title,
                                ),
                              ],
                            ),
                            softWrap: true,
                          ),
                        ],
                        const SizedBox(height: 6),
                        if (_memberController.memberInfo.value.sign != '')
                          SelectableText(
                            _memberController.memberInfo.value.sign!,
                          ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          } else {
            // 骨架屏
            return ProfilePanel(ctr: _memberController, loadingStatus: true);
          }
        },
      ),
    );
  }
}

class _MemberGlassTabSelector extends StatelessWidget {
  const _MemberGlassTabSelector({
    required this.selectedIndex,
    required this.tabs,
    required this.onSelected,
  });

  static const double _height = 38;
  static const double _padding = 3;
  static const LiquidGlassSettings _glassSettings = LiquidGlassSettings(
    thickness: 30,
    blur: 3,
    chromaticAberration: 0.3,
    lightIntensity: 0.6,
    refractiveIndex: 1.59,
    saturation: 0.7,
    ambientStrength: 1,
    lightAngle: 0.7853981633974483,
    glassColor: Color(0x3DFFFFFF),
  );

  final int selectedIndex;
  final List<String> tabs;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    if (tabs.length < 2) return const SizedBox.shrink();

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final int safeIndex = selectedIndex.clamp(0, tabs.length - 1);
    final Color selectedColor = colorScheme.primary;
    final Color unselectedColor = colorScheme.onSurface.withValues(alpha: 0.68);
    final Color indicatorColor = colorScheme.primary.withValues(alpha: 0.32);
    const LiquidShape capsuleShape =
        LiquidRoundedSuperellipse(borderRadius: _height / 2);

    return Material(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: AdaptiveLiquidGlassLayer(
          settings: _glassSettings,
          quality: GlassQuality.standard,
          shape: capsuleShape,
          child: SizedBox(
            height: _height,
            child: AdaptiveGlass.grouped(
              quality: GlassQuality.standard,
              shape: capsuleShape,
              child: GlassSegmentedControl(
                segments: tabs,
                selectedIndex: safeIndex,
                onSegmentSelected: onSelected,
                height: _height,
                borderRadius: _height / 2,
                padding: const EdgeInsets.all(_padding),
                backgroundColor: Colors.transparent,
                indicatorColor: indicatorColor,
                indicatorSettings: const LiquidGlassSettings(
                  glassColor: Colors.transparent,
                  lightIntensity: 0,
                  chromaticAberration: 0,
                  blur: 0,
                ),
                useOwnLayer: false,
                quality: GlassQuality.standard,
                selectedTextStyle: TextStyle(
                  color: selectedColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                unselectedTextStyle: TextStyle(
                  color: unselectedColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
