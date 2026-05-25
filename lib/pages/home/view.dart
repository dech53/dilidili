import 'dart:io';

import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/pages/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

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

  void _runAfterGlassMenuClosed(VoidCallback action) {
    Future<void>.delayed(const Duration(milliseconds: 220), () {
      if (!mounted) return;
      action();
    });
  }

  void _openCurrentUserSpace() {
    if (!_homeController.userLogin.value) {
      Get.toNamed('/loginPage');
      return;
    }

    final userInfo = _homeController.userInfo;
    if (userInfo == null || userInfo.mid == null) {
      SmartDialog.showToast('用户信息加载中');
      return;
    }

    Get.toNamed(
      '/member/mid=${userInfo.mid}',
      arguments: {
        'face': userInfo.face,
        'mid': userInfo.mid.toString(),
      },
      preventDuplicates: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: Platform.isAndroid
            ? SystemUiOverlayStyle(
                statusBarIconBrightness:
                    Theme.of(context).brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark,
              )
            : Theme.of(context).brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
      ),
      body: _getBodyUI(),
    );
  }

  Widget _getBodyUI() {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildTopActions(context),
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

  Widget _buildTopActions(BuildContext context) {
    final Color iconColor = Theme.of(context).colorScheme.onSurface;
    final double actionButtonSize = 40.r;
    final double avatarSize = 28.r;

    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 2.h),
      child: Row(
        children: [
          Obx(
            () {
              final bool hasAvatar = _homeController.userFace.value.isNotEmpty;
              final bool isLogin = _homeController.userLogin.value;
              return GlassMenu(
                menuWidth: 180,
                menuBorderRadius: 18,
                quality: GlassQuality.standard,
                triggerBuilder: (context, toggleMenu) => GlassButton.custom(
                  label: '用户',
                  width: actionButtonSize,
                  height: actionButtonSize,
                  useOwnLayer: true,
                  quality: GlassQuality.standard,
                  onTap: toggleMenu,
                  child: hasAvatar
                      ? NetworkImgLayer(
                          width: avatarSize,
                          height: avatarSize,
                          type: 'avatar',
                          src: _homeController.userFace.value,
                        )
                      : Icon(
                          Icons.person_outline_rounded,
                          size: 22.r,
                          color: iconColor,
                        ),
                ),
                items: isLogin
                    ? [
                        GlassMenuItem(
                          title: '个人主页',
                          icon: ClipOval(
                            child: NetworkImgLayer(
                              width: 20,
                              height: 20,
                              type: 'avatar',
                              src: _homeController.userFace.value,
                            ),
                          ),
                          onTap: () {
                            _runAfterGlassMenuClosed(_openCurrentUserSpace);
                          },
                        ),
                        GlassMenuItem(
                          title: '观看记录',
                          icon: const Icon(Icons.history_rounded),
                          onTap: () {
                            _runAfterGlassMenuClosed(
                              () => Get.toNamed('/history'),
                            );
                          },
                        ),
                        GlassMenuItem(
                          title: '我的收藏',
                          icon: const Icon(Icons.star_border_rounded),
                          onTap: () {
                            _runAfterGlassMenuClosed(() => Get.toNamed('/fav'));
                          },
                        ),
                        GlassMenuItem(
                          title: '稍后再看',
                          icon: const Icon(Icons.watch_later_outlined),
                          onTap: () {
                            _runAfterGlassMenuClosed(
                              () => Get.toNamed('/later'),
                            );
                          },
                        ),
                      ]
                    : [
                        GlassMenuItem(
                          title: '登录账号',
                          icon: const Icon(Icons.login_rounded),
                          onTap: () {
                            _runAfterGlassMenuClosed(
                              () => Get.toNamed('/loginPage'),
                            );
                          },
                        ),
                      ],
              );
            },
          ),
          8.horizontalSpace,
          Obx(
            () => GlassBadge(
              count: _homeController.unreadMsg.value,
              child: GlassButton(
                label: '通知',
                width: actionButtonSize,
                height: actionButtonSize,
                iconSize: 21.r,
                iconColor: iconColor,
                useOwnLayer: true,
                quality: GlassQuality.standard,
                icon: const Icon(Icons.notifications_none_rounded),
                onTap: () {
                  if (_homeController.userLogin.value) {
                    _homeController.unreadMsg.value = 0;
                    Get.toNamed('/whisper');
                  } else {
                    SmartDialog.showToast("用户未登录");
                  }
                },
              ),
            ),
          ),
          const Spacer(),
          const HomeTabSelector(),
        ],
      ),
    );
  }
}

class HomeTabSelector extends StatelessWidget {
  const HomeTabSelector({super.key});

  static const double _controlWidth = 208;
  static const double _controlHeight = 40;
  static const double _controlPadding = 3;
  static const LiquidGlassSettings _bottomNavigationGlassSettings =
      LiquidGlassSettings(
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

  void _selectTab(HomeController homeController, int index) {
    if (homeController.initialIndex.value == index) {
      homeController.tabsCtrList[index]().animateToTop();
    }
    homeController.initialIndex.value = index;
    homeController.tabController.index = index;
  }

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color selectedColor = colorScheme.primary;
    final Color unselectedColor = colorScheme.onSurface.withValues(alpha: 0.68);
    final Color indicatorColor = colorScheme.primary.withValues(alpha: 0.32);

    return Obx(() {
      if (homeController.tabs.isEmpty) {
        return const SizedBox(width: _controlWidth, height: _controlHeight);
      }

      final int selectedIndex = homeController.initialIndex.value
          .clamp(0, homeController.tabs.length - 1)
          .toInt();
      final List<String> labels = homeController.tabs
          .map<String>((tab) => (tab as Map)['label'] as String)
          .toList();
      final LiquidShape capsuleShape =
          LiquidRoundedSuperellipse(borderRadius: _controlHeight.r / 2);

      return AdaptiveLiquidGlassLayer(
        settings: _bottomNavigationGlassSettings,
        quality: GlassQuality.standard,
        shape: capsuleShape,
        child: SizedBox(
          width: _controlWidth.w,
          height: _controlHeight.h,
          child: AdaptiveGlass.grouped(
            quality: GlassQuality.standard,
            shape: capsuleShape,
            child: GlassSegmentedControl(
              segments: labels,
              selectedIndex: selectedIndex,
              onSegmentSelected: (index) => _selectTab(homeController, index),
              height: _controlHeight.h,
              borderRadius: _controlHeight.r / 2,
              padding: EdgeInsets.all(_controlPadding.r),
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
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
              unselectedTextStyle: TextStyle(
                color: unselectedColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }
}
