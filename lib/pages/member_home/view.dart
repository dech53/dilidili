import 'dart:math' as math;

import 'package:dilidili/common/constants.dart';
import 'package:dilidili/model/space/space/data.dart';
import 'package:dilidili/model/space/space/setting.dart';
import 'package:dilidili/pages/member_home/controller.dart';
import 'package:dilidili/pages/member_home/widgets/archive_card.dart';
import 'package:dilidili/pages/member_home/widgets/article_item.dart';
import 'package:dilidili/pages/member_home/widgets/audio_item.dart';
import 'package:dilidili/pages/member_home/widgets/fav_item.dart';
import 'package:dilidili/pages/member_home/widgets/poster_card.dart';
import 'package:dilidili/pages/member_home/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberHomePage extends StatefulWidget {
  const MemberHomePage({
    super.key,
    required this.mid,
    this.heroTag,
  });

  final int mid;
  final String? heroTag;

  @override
  State<MemberHomePage> createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage>
    with AutomaticKeepAliveClientMixin {
  late final MemberHomeController controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final String tag = widget.mid.toString();
    controller = Get.isRegistered<MemberHomeController>(tag: tag)
        ? Get.find<MemberHomeController>(tag: tag)
        : Get.put(
            MemberHomeController(mid: widget.mid, heroTag: widget.heroTag),
            tag: tag,
          );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      final SpaceData? spaceData = controller.memberController.spaceData.value;
      if (spaceData == null) {
        return const CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        );
      }

      final List<Widget> slivers = _buildSections(context, spaceData);
      if (slivers.isEmpty) {
        return CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  '暂无主页内容',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ),
          ],
        );
      }

      return CustomScrollView(
        slivers: [
          ...slivers,
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100 + MediaQuery.viewPaddingOf(context).bottom,
            ),
          ),
        ],
      );
    });
  }

  List<Widget> _buildSections(BuildContext context, SpaceData data) {
    final bool isVertical = MediaQuery.sizeOf(context).width < 600;
    final bool isOwner = controller.memberController.isOwner.value;
    final SpaceSetting? setting = data.setting;
    final List<Widget> slivers = [];

    if (data.archive?.item?.isNotEmpty == true) {
      slivers.addAll([
        MemberHomeSectionHeader(
          title: '视频',
          count: data.archive!.count ?? data.archive!.item!.length,
          onMore: () => controller.jumpToTab('contribute'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StyleString.safeSpace,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: _videoGridDelegate(context),
            itemBuilder: (context, index) {
              return MemberHomeArchiveCard(item: data.archive!.item![index]);
            },
            itemCount: math.min(isVertical ? 4 : 8, data.archive!.item!.length),
          ),
        ),
      ]);
    }

    if (data.favourite2?.item?.isNotEmpty == true) {
      slivers.addAll([
        MemberHomeSectionHeader(
          title: '收藏',
          count: data.favourite2!.count ?? data.favourite2!.item!.length,
          visible: isOwner && setting != null ? setting.favVideo == 1 : null,
          onMore: () => controller.jumpToTab('favorite'),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 98,
            child: MemberHomeFavItem(
              item: data.favourite2!.item!.first,
              isOwner: isOwner,
            ),
          ),
        ),
      ]);
    }

    if (data.coinArchive?.item?.isNotEmpty == true) {
      slivers.addAll([
        MemberHomeSectionHeader(
          title: '最近投币的视频',
          count: data.coinArchive!.count ?? data.coinArchive!.item!.length,
          visible: isOwner && setting != null ? setting.coinsVideo == 1 : null,
          onMore: () => controller.jumpToTab(
            'coinArchive',
            fallbackMessage: '暂未实现最近投币列表',
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StyleString.safeSpace,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: _videoGridDelegate(context),
            itemBuilder: (context, index) {
              return MemberHomeArchiveCard(
                item: data.coinArchive!.item![index],
              );
            },
            itemCount:
                math.min(isVertical ? 2 : 4, data.coinArchive!.item!.length),
          ),
        ),
      ]);
    }

    if (data.likeArchive?.item?.isNotEmpty == true) {
      slivers.addAll([
        MemberHomeSectionHeader(
          title: '最近点赞的视频',
          count: data.likeArchive!.count ?? data.likeArchive!.item!.length,
          visible: isOwner && setting != null ? setting.likesVideo == 1 : null,
          onMore: () => controller.jumpToTab(
            'likeArchive',
            fallbackMessage: '暂未实现最近点赞列表',
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StyleString.safeSpace,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: _videoGridDelegate(context),
            itemBuilder: (context, index) {
              return MemberHomeArchiveCard(
                item: data.likeArchive!.item![index],
              );
            },
            itemCount:
                math.min(isVertical ? 2 : 4, data.likeArchive!.item!.length),
          ),
        ),
      ]);
    }

    if (data.article?.item?.isNotEmpty == true) {
      slivers.addAll([
        MemberHomeSectionHeader(
          title: '图文',
          count: data.article!.count ?? data.article!.item!.length,
          onMore: () => controller.jumpToTab('contribute'),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 98,
            child: MemberHomeArticleItem(item: data.article!.item!.first),
          ),
        ),
      ]);
    }

    if (data.audios?.item?.isNotEmpty == true) {
      slivers.addAll([
        MemberHomeSectionHeader(
          title: '音频',
          count: data.audios!.count ?? data.audios!.item!.length,
          onMore: () => controller.jumpToTab('contribute'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StyleString.safeSpace,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: _audioGridDelegate,
            itemBuilder: (context, index) {
              return MemberHomeAudioItem(item: data.audios!.item![index]);
            },
            itemCount: math.min(isVertical ? 1 : 3, data.audios!.item!.length),
          ),
        ),
      ]);
    }

    if (data.comic?.item?.isNotEmpty == true) {
      slivers.addAll([
        MemberHomeSectionHeader(
          title: '漫画',
          count: data.comic!.count ?? data.comic!.item!.length,
          onMore: () => controller.jumpToTab('contribute'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StyleString.safeSpace,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: _posterGridDelegate(context),
            itemBuilder: (context, index) {
              return MemberHomePosterCard(item: data.comic!.item![index]);
            },
            itemCount: math.min(isVertical ? 2 : 6, data.comic!.item!.length),
          ),
        ),
      ]);
    }

    if (data.season?.item?.isNotEmpty == true) {
      slivers.addAll([
        MemberHomeSectionHeader(
          title: '追番',
          count: data.season!.count ?? data.season!.item!.length,
          visible: isOwner && setting != null ? setting.bangumi == 1 : null,
          onMore: () => controller.jumpToTab('bangumi'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StyleString.safeSpace,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: _posterGridDelegate(context),
            itemBuilder: (context, index) {
              return MemberHomePosterCard(
                item: data.season!.item![index],
                isSeason: true,
              );
            },
            itemCount: math.min(isVertical ? 3 : 6, data.season!.item!.length),
          ),
        ),
      ]);
    }

    return slivers;
  }

  SliverGridDelegateWithMaxCrossAxisExtent _videoGridDelegate(
    BuildContext context,
  ) {
    return SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 240,
      mainAxisSpacing: StyleString.cardSpace,
      crossAxisSpacing: StyleString.cardSpace,
      mainAxisExtent: 118 + MediaQuery.textScalerOf(context).scale(50),
    );
  }

  SliverGridDelegateWithMaxCrossAxisExtent get _audioGridDelegate {
    return const SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 480,
      mainAxisSpacing: StyleString.cardSpace,
      crossAxisSpacing: StyleString.cardSpace,
      mainAxisExtent: 82,
    );
  }

  SliverGridDelegateWithMaxCrossAxisExtent _posterGridDelegate(
    BuildContext context,
  ) {
    return SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 150,
      mainAxisSpacing: StyleString.cardSpace,
      crossAxisSpacing: StyleString.cardSpace,
      mainAxisExtent: 164 + MediaQuery.textScalerOf(context).scale(50),
    );
  }
}
