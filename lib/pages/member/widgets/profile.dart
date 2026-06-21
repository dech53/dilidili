import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/live/item.dart';
import 'package:dilidili/model/member/member_info.dart';
import 'package:dilidili/model/model_owner.dart';
import 'package:dilidili/model/space/space/card.dart';
import 'package:dilidili/model/space/space/data.dart';
import 'package:dilidili/model/space/space/followings_followed_upper.dart';
import 'package:dilidili/model/space/space/images.dart';
import 'package:dilidili/model/space/space/space_tag.dart';
import 'package:dilidili/model/space/space/top.dart';
import 'package:dilidili/pages/follow_type/followed/view.dart';
import 'package:dilidili/pages/gallery/preview.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ProfilePanel extends StatelessWidget {
  final dynamic ctr;
  final bool loadingStatus;
  const ProfilePanel({
    super.key,
    required this.ctr,
    this.loadingStatus = false,
  });

  static const double _headerHeight = 155;
  static const double _avatarSize = 82;
  static const double _avatarShellSize = 108;
  static const double _avatarTop = _headerHeight - 20;
  static const double _actionsTop = _headerHeight + 5;
  static const double _actionsLeft = 160;
  static const double _actionsRight = 15;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Obx(() {
      final MemberInfo memberInfo = ctr.memberInfo.value;
      final SpaceData? spaceData = ctr.spaceData.value;
      final SpaceCard? card = spaceData?.card;
      final bool isProfileLoading = loadingStatus || card == null;
      final SpaceImages? spaceImages = spaceData?.images;

      return Material(
        color: colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: _headerHeight + 90,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _CoverImage(
                    images: isProfileLoading ? null : spaceImages,
                    src: isProfileLoading
                        ? null
                        : _coverUrl(context, memberInfo, spaceImages),
                    pageController: ctr.headerPageController,
                  ),
                  Positioned(
                    left: 20,
                    top: _avatarTop,
                    child: _buildAvatar(
                      context,
                      spaceData,
                      card,
                      memberInfo,
                      colorScheme,
                      isProfileLoading,
                    ),
                  ),
                  Positioned(
                    left: _actionsLeft,
                    right: _actionsRight,
                    top: _actionsTop,
                    child: _buildRightPanel(
                      context,
                      card,
                      colorScheme,
                      isProfileLoading,
                    ),
                  ),
                ],
              ),
            ),
            if (isProfileLoading)
              const _InfoSkeleton()
            else ...[
              _buildNameRow(context, card, memberInfo, colorScheme),
              _buildVerify(context, card, memberInfo, colorScheme),
              _buildSign(card, colorScheme),
              _buildElec(memberInfo, colorScheme),
              if (card.followingsFollowedUpper?.items?.isNotEmpty == true)
                _buildFollowedUp(
                  context,
                  colorScheme,
                  card.followingsFollowedUpper!,
                  card,
                ),
              _buildExtraInfo(card, memberInfo, colorScheme),
              _buildBanNotice(card, colorScheme),
              const SizedBox(height: 10),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildAvatar(
    BuildContext context,
    SpaceData? spaceData,
    SpaceCard? card,
    MemberInfo memberInfo,
    ColorScheme colorScheme,
    bool isProfileLoading,
  ) {
    final String avatar = isProfileLoading ? '' : card?.face ?? '';
    final String pendant = card?.pendant?.image?.isNotEmpty == true
        ? card!.pendant!.image!
        : memberInfo.pendant?.imageEnhance?.isNotEmpty == true
            ? memberInfo.pendant!.imageEnhance!
            : memberInfo.pendant?.image ?? '';
    final bool isLive = spaceData?.live?.liveStatus == 1;

    return Hero(
      tag: ctr.heroTag ?? '',
      child: SizedBox(
        width: _avatarShellSize,
        height: _avatarShellSize,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: _avatarSize + 8,
              height: _avatarSize + 8,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: NetworkImgLayer(
                width: _avatarSize,
                height: _avatarSize,
                type: 'avatar',
                src: avatar,
              ),
            ),
            if (!isProfileLoading && pendant.isNotEmpty)
              CachedNetworkImage(
                imageUrl: _imageUrl(pendant, quality: 20),
                width: _avatarShellSize,
                height: _avatarShellSize,
                fit: BoxFit.contain,
                placeholder: (context, url) => const SizedBox.shrink(),
                errorWidget: (context, url, error) => const SizedBox.shrink(),
              ),
            if (!isProfileLoading && isLive)
              Positioned(
                left: 17,
                right: 17,
                bottom: 7,
                child: GestureDetector(
                  onTap: () => _openLiveRoom(spaceData, card),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/live.gif', height: 10),
                        const SizedBox(width: 3),
                        const Text(
                          '直播中',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPanel(
    BuildContext context,
    SpaceCard? card,
    ColorScheme colorScheme,
    bool isProfileLoading,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: _StatItem(
                value: _statValue(card?.attention, isProfileLoading),
                label: '关注',
                onTap: isProfileLoading
                    ? null
                    : () {
                        final String mid = card?.mid ?? ctr.mid.toString();
                        Get.toNamed(
                          '/follow?mid=$mid&name=${card?.name ?? ''}',
                          arguments: {
                            'mid': mid,
                            'name': card?.name,
                          },
                        );
                      },
              ),
            ),
            _Divider(colorScheme: colorScheme),
            Expanded(
              child: _StatItem(
                value: _statValue(card?.fans, isProfileLoading),
                label: '粉丝',
                onTap: isProfileLoading
                    ? null
                    : () {
                        final String mid = card?.mid ?? ctr.mid.toString();
                        Get.toNamed(
                          '/fan?mid=$mid&name=${card?.name ?? ''}',
                        );
                      },
              ),
            ),
            _Divider(colorScheme: colorScheme),
            Expanded(
              child: _StatItem(
                value: _statValue(card?.likes?.likeNum, isProfileLoading),
                label: '获赞',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildActionRow(context, card, colorScheme, isProfileLoading),
      ],
    );
  }

  Widget _buildActionRow(
    BuildContext context,
    SpaceCard? card,
    ColorScheme colorScheme,
    bool isProfileLoading,
  ) {
    if (ctr.ownerMid == ctr.mid && ctr.ownerMid != -1) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton.tonal(
          onPressed: isProfileLoading ? null : () {},
          style: FilledButton.styleFrom(
            visualDensity: const VisualDensity(vertical: -2),
          ),
          child: const Text('编辑资料'),
        ),
      );
    }

    return Row(
      children: [
        IconButton.outlined(
          onPressed: isProfileLoading || card == null
              ? null
              : () => _openWhisper(card),
          icon: const Icon(Icons.mail_outline, size: 20),
          style: IconButton.styleFrom(
            side: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.28),
            ),
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Obx(
            () => FilledButton.tonal(
              onPressed: isProfileLoading ? null : ctr.actionRelationMod,
              style: FilledButton.styleFrom(
                backgroundColor: ctr.attribute.value != 0
                    ? colorScheme.onInverseSurface
                    : null,
                foregroundColor:
                    ctr.attribute.value != 0 ? colorScheme.outline : null,
                visualDensity: const VisualDensity(vertical: -2),
              ),
              child: Text(ctr.attributeText.value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameRow(
    BuildContext context,
    SpaceCard card,
    MemberInfo memberInfo,
    ColorScheme colorScheme,
  ) {
    final String vipText = card.vip?.label?.text ?? '大会员';
    final int? level = card.levelInfo?.currentLevel ?? memberInfo.level;
    final medal = card.liveFansWearing?.detailV2;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
      child: Wrap(
        spacing: 7,
        runSpacing: 7,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SelectableText(
            card.name ?? '',
            style: TextStyle(
              height: 1,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          if (memberInfo.sex == '女')
            const Icon(FontAwesomeIcons.venus, size: 14, color: Colors.pink),
          if (memberInfo.sex == '男')
            const Icon(FontAwesomeIcons.mars, size: 14, color: Colors.blue),
          if (level != null)
            Image.asset(
              'assets/images/lv/lv$level.png',
              height: 11,
            ),
          if (card.vip?.status == 1) _VipLabel(text: vipText),
          if (medal?.medalName?.isNotEmpty == true)
            _MedalLabel(
              name: medal!.medalName!,
              level: medal.level,
            ),
        ],
      ),
    );
  }

  Widget _buildVerify(
    BuildContext context,
    SpaceCard card,
    MemberInfo memberInfo,
    ColorScheme colorScheme,
  ) {
    final String title = _verifyTitle(card, memberInfo);
    if (title.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 9, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                Icons.offline_bolt,
                size: 17,
                color: card.officialVerify?.type == 0
                    ? const Color(0xFFFFCC00)
                    : Colors.lightBlueAccent,
              ),
            ),
            const TextSpan(text: ' '),
            TextSpan(text: title),
          ],
        ),
        style: TextStyle(
          height: 1.1,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface.withValues(alpha: 0.72),
        ),
      ),
    );
  }

  Widget _buildSign(SpaceCard card, ColorScheme colorScheme) {
    final String sign =
        (card.sign ?? '').trim().replaceAll(RegExp(r'\n{2,}'), '\n');
    if (sign.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 8, right: 20),
      child: SelectableText(
        sign,
        style: TextStyle(
          fontSize: 14,
          height: 1.35,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildElec(MemberInfo memberInfo, ColorScheme colorScheme) {
    final ShowInfo? showInfo = memberInfo.elec?.showInfo;
    if (showInfo?.show != true || showInfo?.title?.isNotEmpty != true) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 8, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showInfo!.icon?.isNotEmpty == true) ...[
            CachedNetworkImage(
              imageUrl: _imageUrl(showInfo.icon!, quality: 20),
              width: 18,
              height: 18,
              placeholder: (context, url) => const SizedBox.shrink(),
              errorWidget: (context, url, error) => const SizedBox.shrink(),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            showInfo.title!,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowedUp(
    BuildContext context,
    ColorScheme colorScheme,
    FollowingsFollowedUpper item,
    SpaceCard card,
  ) {
    final List<Owner> allUsers = item.items ?? <Owner>[];
    if (allUsers.isEmpty) return const SizedBox.shrink();

    final bool hasMore = allUsers.length > 3;
    final List<Owner> users = hasMore ? allUsers.take(3).toList() : allUsers;
    final String names = users
        .map((item) => item.name ?? '')
        .where((name) => name.isNotEmpty)
        .join('、');

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openFollowedUp(card),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 6, right: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _avatars(
              gap: 10,
              colorScheme: colorScheme,
              users: users,
            ),
            const SizedBox(width: 4),
            if (names.isNotEmpty)
              Flexible(
                child: Text(
                  names,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            Text(
              '${hasMore ? '等${allUsers.length}人' : ''}也关注了TA',
              style: TextStyle(fontSize: 13, color: colorScheme.outline),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 20,
              color: colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatars({
    required ColorScheme colorScheme,
    required List<Owner> users,
    double gap = 6,
  }) {
    const double size = 22;
    const double padding = 0.8;
    const double imgSize = size - 2 * padding;
    final double offset = size - gap;
    if (users.length == 1) {
      return NetworkImgLayer(
        src: users.first.face,
        width: imgSize,
        height: imgSize,
        type: 'avatar',
      );
    }

    final BoxDecoration decoration = BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: colorScheme.surface),
    );
    return SizedBox(
      height: size,
      width: offset * users.length + gap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (int index = 0; index < users.length; index++)
            Positioned(
              top: 0,
              bottom: 0,
              width: size,
              left: index * offset,
              child: DecoratedBox(
                decoration: decoration,
                child: Padding(
                  padding: const EdgeInsets.all(padding),
                  child: NetworkImgLayer(
                    src: users[index].face,
                    width: imgSize,
                    height: imgSize,
                    type: 'avatar',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openFollowedUp(SpaceCard card) {
    FollowedPage.toFollowedPage(
      mid: card.mid ?? ctr.mid,
      name: card.name,
    );
  }

  Widget _buildExtraInfo(
    SpaceCard card,
    MemberInfo memberInfo,
    ColorScheme colorScheme,
  ) {
    final List<Widget> items = [
      Text(
        'UID: ${card.mid ?? ctr.mid}',
        style: TextStyle(fontSize: 12, color: colorScheme.outline),
      ),
    ];
    for (final SpaceTag item in card.spaceTag ?? <SpaceTag>[]) {
      if (item.title?.isNotEmpty == true) {
        items.add(
          Text(
            item.title!,
            style: TextStyle(fontSize: 12, color: colorScheme.outline),
          ),
        );
      }
    }
    if (memberInfo.school?.name?.isNotEmpty == true) {
      items.add(
        Text(
          memberInfo.school!.name!,
          style: TextStyle(fontSize: 12, color: colorScheme.outline),
        ),
      );
    }
    if (memberInfo.profession?.name?.isNotEmpty == true) {
      items.add(
        Text(
          memberInfo.profession!.name!,
          style: TextStyle(fontSize: 12, color: colorScheme.outline),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 8, right: 20),
      child: Wrap(
        spacing: 10,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: items,
      ),
    );
  }

  Widget _buildBanNotice(SpaceCard card, ColorScheme colorScheme) {
    if (card.silence != 1) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 20, top: 10, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '该账号封禁中',
        style: TextStyle(
          fontSize: 13,
          color: colorScheme.onErrorContainer,
        ),
      ),
    );
  }

  void _openLiveRoom(SpaceData? spaceData, SpaceCard? card) {
    final liveRoom = spaceData?.live;
    if (liveRoom?.roomid == null) return;
    final room = liveRoom!;
    final LiveItemModel liveItem = LiveItemModel.fromJson({
      'title': room.title,
      'uname': card?.name,
      'face': card?.face,
      'roomid': room.roomid,
      'watched_show': {'text_large': ''},
    });
    Get.toNamed(
      '/liveRoom?roomid=${room.roomid}',
      arguments: {'liveItem': liveItem},
    );
  }

  void _openWhisper(SpaceCard card) {
    final int mid = int.tryParse(card.mid ?? '') ?? ctr.mid;
    Get.toNamed(
      '/whisperDetail',
      parameters: {
        'talkerId': mid.toString(),
        'name': card.name ?? '',
        'face': card.face ?? '',
        'mid': mid.toString(),
        'heroTag': ctr.heroTag ?? '',
      },
    );
  }

  String _statValue(int? value, bool isProfileLoading) {
    if (isProfileLoading || value == null) return '-';
    return NumUtils.int2Num(value);
  }

  String _coverUrl(
    BuildContext context,
    MemberInfo memberInfo,
    SpaceImages? spaceImages,
  ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark && spaceImages?.nightImgurl?.isNotEmpty == true) {
      return spaceImages!.nightImgurl!;
    }
    if (spaceImages?.imgUrl?.isNotEmpty == true) {
      return spaceImages!.imgUrl!;
    }
    if (spaceImages?.nightImgurl?.isNotEmpty == true) {
      return spaceImages!.nightImgurl!;
    }
    if (memberInfo.topPhotoV2?.l200HImg?.isNotEmpty == true) {
      return memberInfo.topPhotoV2!.l200HImg!;
    }
    if (memberInfo.topPhotoV2?.lImg?.isNotEmpty == true) {
      return memberInfo.topPhotoV2!.lImg!;
    }
    return memberInfo.topPhoto ?? '';
  }

  String _verifyTitle(SpaceCard card, MemberInfo memberInfo) {
    if (card.officialVerify?.desc?.isNotEmpty == true) {
      return card.officialVerify!.desc!;
    }
    if (card.officialVerify?.spliceTitle?.isNotEmpty == true) {
      return card.officialVerify!.spliceTitle!;
    }
    if (memberInfo.official?.title?.isNotEmpty == true) {
      return '${memberInfo.official!.role == 1 ? '个人认证：' : '企业认证：'}${memberInfo.official!.title!}';
    }
    if (memberInfo.attestation?.spliceInfo?.title?.isNotEmpty == true) {
      return memberInfo.attestation!.spliceInfo!.title!;
    }
    if (memberInfo.attestation?.commonInfo?.title?.isNotEmpty == true) {
      return memberInfo.attestation!.commonInfo!.title!;
    }
    return memberInfo.attestation?.desc ?? '';
  }

  static String _imageUrl(String src, {int quality = 30}) {
    final String normalized = src.startsWith('//') ? 'https:$src' : src;
    if (normalized.contains('@')) return normalized;
    return '$normalized@${quality}q.webp';
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({
    this.images,
    this.src,
    required this.pageController,
  });

  final SpaceImages? images;
  final String? src;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final List<TopImage>? collectionImages =
        images?.collectionTopSimple?.top?.imgUrls;
    if (collectionImages != null && collectionImages.isNotEmpty) {
      return _buildCollectionHeader(context, collectionImages);
    }

    final String? previewSource = src?.isNotEmpty == true ? src : null;
    final Object? heroTag = previewSource == null
        ? null
        : _coverHeroTag(previewSource, 0, prefix: 'member_top_cover');
    return SizedBox(
      width: double.infinity,
      height: ProfilePanel._headerHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (src?.isNotEmpty == true)
            Hero(
              tag: heroTag!,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => openGalleryPreview(
                  context,
                  sources: [previewSource],
                  initIndex: 0,
                  heroTags: [heroTag],
                ),
                child: CachedNetworkImage(
                  imageUrl: ProfilePanel._imageUrl(src!, quality: 45),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  color: Theme.of(context).brightness == Brightness.light
                      ? const Color(0x5DFFFFFF)
                      : const Color(0x8D000000),
                  colorBlendMode:
                      Theme.of(context).brightness == Brightness.light
                          ? BlendMode.lighten
                          : BlendMode.darken,
                  placeholder: (context, url) => _coverPlaceholder(colorScheme),
                  errorWidget: (context, url, error) =>
                      _coverPlaceholder(colorScheme),
                ),
              ),
            )
          else
            _coverPlaceholder(colorScheme),
        ],
      ),
    );
  }

  Widget _buildCollectionHeader(
    BuildContext context,
    List<TopImage> collectionImages,
  ) {
    final List<String> previewSources = _collectionPreviewSources(
      collectionImages,
    );
    final List<Object> heroTags = _collectionHeroTags(collectionImages);
    if (collectionImages.length == 1) {
      final TopImage image = collectionImages.first;
      final Widget header = _CollectionHeaderImage(
        image: image,
        heroTag: heroTags.first,
        onTap: () => _openCollectionPreview(
          context,
          previewSources,
          heroTags,
          0,
        ),
      );
      final TopTitle? title = image.title;
      if (title == null) return header;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          header,
          Positioned(
            right: 0,
            bottom: 0,
            child: _HeaderTitleWrapper(child: _HeaderTitleText(title: title)),
          ),
        ],
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: double.infinity,
          height: ProfilePanel._headerHeight,
          child: PageView.builder(
            controller: pageController,
            itemCount: collectionImages.length,
            itemBuilder: (context, index) {
              return _CollectionHeaderImage(
                image: collectionImages[index],
                heroTag: heroTags[index],
                onTap: () => _openCollectionPreview(
                  context,
                  previewSources,
                  heroTags,
                  index,
                ),
              );
            },
          ),
        ),
        Positioned(
          right: 0,
          bottom: 3.5,
          child: _HeaderTitleWrapper(
            child: _HeaderTitlePager(
              images: collectionImages,
              pageController: pageController,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _HeaderIndicator(
            length: collectionImages.length,
            pageController: pageController,
          ),
        ),
      ],
    );
  }

  List<String> _collectionPreviewSources(List<TopImage> images) {
    return images
        .map((image) {
          if (image.fullCover.isNotEmpty) return image.fullCover;
          return image.header;
        })
        .where((url) => url.isNotEmpty)
        .toList();
  }

  List<Object> _collectionHeroTags(List<TopImage> images) {
    return List<Object>.generate(
      images.length,
      (index) => _coverHeroTag(
        images[index].fullCover.isNotEmpty
            ? images[index].fullCover
            : images[index].header,
        index,
        prefix: 'member_top_collection',
      ),
    );
  }

  Object _coverHeroTag(
    String source,
    int index, {
    required String prefix,
  }) {
    return '${prefix}_${source.hashCode}_$index';
  }

  void _openCollectionPreview(
    BuildContext context,
    List<String> sources,
    List<Object> heroTags,
    int index,
  ) {
    if (sources.isEmpty) return;
    openGalleryPreview(
      context,
      sources: sources,
      initIndex: index,
      heroTags: heroTags,
    );
  }

  Widget _coverPlaceholder(ColorScheme colorScheme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.72),
            colorScheme.tertiaryContainer.withValues(alpha: 0.72),
          ],
        ),
      ),
    );
  }
}

class _CollectionHeaderImage extends StatelessWidget {
  const _CollectionHeaderImage({
    required this.image,
    required this.heroTag,
    required this.onTap,
  });

  final TopImage image;
  final Object heroTag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          height: ProfilePanel._headerHeight,
          child: CachedNetworkImage(
            imageUrl: ProfilePanel._imageUrl(image.header, quality: 45),
            fit: BoxFit.cover,
            alignment: Alignment(0, image.dy),
            placeholder: (context, url) => const SizedBox(
              width: double.infinity,
              height: ProfilePanel._headerHeight,
            ),
            errorWidget: (context, url, error) => DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.72),
                    Theme.of(context)
                        .colorScheme
                        .tertiaryContainer
                        .withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderIndicator extends StatefulWidget {
  const _HeaderIndicator({
    required this.length,
    required this.pageController,
  });

  final int length;
  final PageController pageController;

  @override
  State<_HeaderIndicator> createState() => _HeaderIndicatorState();
}

class _HeaderIndicatorState extends State<_HeaderIndicator> {
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _updateProgress();
    widget.pageController.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant _HeaderIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageController != widget.pageController) {
      oldWidget.pageController.removeListener(_listener);
      widget.pageController.addListener(_listener);
    }
    _updateProgress();
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    _updateProgress();
    if (mounted) setState(() {});
  }

  void _updateProgress() {
    if (widget.length <= 0) {
      _progress = 0;
      return;
    }
    final double page = widget.pageController.hasClients
        ? widget.pageController.page ??
            widget.pageController.initialPage.toDouble()
        : widget.pageController.initialPage.toDouble();
    _progress = ((page + 1) / widget.length).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      minHeight: 3.5,
      backgroundColor: const Color(0xA09E9E9E),
      value: _progress,
    );
  }
}

class _HeaderTitlePager extends StatefulWidget {
  const _HeaderTitlePager({
    required this.images,
    required this.pageController,
  });

  final List<TopImage> images;
  final PageController pageController;

  @override
  State<_HeaderTitlePager> createState() => _HeaderTitlePagerState();
}

class _HeaderTitlePagerState extends State<_HeaderTitlePager> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _updateIndex();
    widget.pageController.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant _HeaderTitlePager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageController != widget.pageController) {
      oldWidget.pageController.removeListener(_listener);
      widget.pageController.addListener(_listener);
    }
    _updateIndex();
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    _updateIndex();
    if (mounted) setState(() {});
  }

  void _updateIndex() {
    if (widget.images.isEmpty) {
      _index = 0;
      return;
    }
    final double page = widget.pageController.hasClients
        ? widget.pageController.page ??
            widget.pageController.initialPage.toDouble()
        : widget.pageController.initialPage.toDouble();
    _index = page.round().clamp(0, widget.images.length - 1).toInt();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();
    final TopTitle? title = widget.images[_index].title;
    if (title == null) return const SizedBox.shrink();
    return _HeaderTitleText(title: title);
  }
}

class _HeaderTitleText extends StatelessWidget {
  const _HeaderTitleText({required this.title});

  final TopTitle title;

  @override
  Widget build(BuildContext context) {
    final String? titleText = title.title;
    final String? subTitle = title.subTitle;
    if ((titleText == null || titleText.isEmpty) &&
        (subTitle == null || subTitle.isEmpty)) {
      return const SizedBox.shrink();
    }
    final List<String>? colors = title.subTitleColorFormat?.colors;
    final Color? subTitleColor = colors == null || colors.isEmpty
        ? null
        : _parseColorString(colors.last);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (titleText?.isNotEmpty == true)
          Text(
            titleText!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              height: 1.15,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        if (subTitle?.isNotEmpty == true)
          Text(
            subTitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              height: 1.15,
              fontSize: 12,
              fontFamily: 'digital_id_num',
              color: subTitleColor ?? Colors.white,
            ),
          ),
      ],
    );
  }
}

class _HeaderTitleWrapper extends StatelessWidget {
  const _HeaderTitleWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 125),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                Colors.black12,
                Colors.black38,
                Colors.black45,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 5, bottom: 2),
            child: child,
          ),
        ),
      ),
    );
  }
}

Color? _parseColorString(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  try {
    String hex = raw.trim();
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    } else if (hex.startsWith('0x')) {
      hex = hex.substring(2);
    }
    if (hex.length == 3) {
      hex = hex.split('').map((item) => '$item$item').join();
    }
    if (hex.length == 6) {
      return Color(int.parse('0xFF$hex'));
    }
    if (hex.length == 8) {
      return Color(int.parse('0x$hex'));
    }
  } catch (_) {
    return null;
  }
  return null;
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    this.onTap,
  });

  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                height: 1.1,
                color: colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1,
      height: 18,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.outline.withValues(alpha: 0.22),
        ),
      ),
    );
  }
}

class _VipLabel extends StatelessWidget {
  const _VipLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6699),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          height: 1,
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MedalLabel extends StatelessWidget {
  const _MedalLabel({required this.name, this.level});

  final String name;
  final int? level;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        level == null ? name : '$name Lv.$level',
        style: TextStyle(
          height: 1,
          fontSize: 10,
          color: colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoSkeleton extends StatelessWidget {
  const _InfoSkeleton();

  @override
  Widget build(BuildContext context) {
    final Color color =
        Theme.of(context).colorScheme.onInverseSurface.withValues(alpha: 0.65);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonLine(width: 150, height: 20, color: color),
          const SizedBox(height: 10),
          _SkeletonLine(width: double.infinity, height: 14, color: color),
          const SizedBox(height: 8),
          _SkeletonLine(width: 210, height: 14, color: color),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}
