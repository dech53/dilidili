import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthorPanel extends StatelessWidget {
  const AuthorPanel({
    super.key,
    this.item,
    this.isDetail = false,
  });

  final dynamic item;
  final bool isDetail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final moduleAuthor = item.modules?.moduleAuthor;
    if (moduleAuthor == null) {
      return const SizedBox.shrink();
    }

    final moreButton = isDetail
        ? null
        : SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              tooltip: '更多',
              padding: EdgeInsets.zero,
              onPressed: () => _showMore(context),
              icon: const Icon(Icons.more_vert_outlined, size: 18),
            ),
          );

    Widget header = GestureDetector(
      onTap: moduleAuthor.type == 'AUTHOR_TYPE_PGC'
          ? null
          : () => _openMember(moduleAuthor),
      child: Row(
        children: [
          _AvatarWithPendant(author: moduleAuthor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  moduleAuthor.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _isVip(moduleAuthor)
                        ? const Color.fromARGB(255, 251, 100, 163)
                        : theme.colorScheme.onSurface,
                    fontSize: theme.textTheme.titleSmall?.fontSize,
                  ),
                ),
                _buildPubLine(theme, moduleAuthor),
              ],
            ),
          ),
        ],
      ),
    );

    final tagText = !isDetail ? item.modules?.moduleTag?.text : null;
    if (tagText != null && tagText.toString().isNotEmpty) {
      header = Row(
        children: [
          Expanded(child: header),
          _ModuleTag(text: tagText),
          if (moreButton != null) moreButton,
        ],
      );
    } else if (moduleAuthor.decorate?.cardUrl?.isNotEmpty == true) {
      header = _DecoratedAuthorHeader(
        authorHeader: header,
        decorate: moduleAuthor.decorate,
        moreButton: moreButton,
      );
    } else if (moreButton != null) {
      header = Row(children: [Expanded(child: header), moreButton]);
    }

    return header;
  }

  Widget _buildPubLine(ThemeData theme, dynamic moduleAuthor) {
    final pubTime = moduleAuthor.pubTime != null &&
            moduleAuthor.pubTime.toString().isNotEmpty
        ? moduleAuthor.pubTime.toString()
        : NumUtils.dateFormat(moduleAuthor.pubTs);
    final pubAction = moduleAuthor.pubAction?.toString() ?? '';
    final badgeText = moduleAuthor.badgeText?.toString();
    return DefaultTextStyle.merge(
      style: TextStyle(
        color: theme.colorScheme.outline,
        fontSize: theme.textTheme.labelSmall?.fontSize,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              '$pubTime${pubAction.isEmpty ? '' : ' $pubAction'}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (badgeText?.isNotEmpty == true) ...[
            const SizedBox(width: 5),
            Text(
              badgeText!,
              style: TextStyle(color: theme.colorScheme.secondary),
            ),
          ],
        ],
      ),
    );
  }

  bool _isVip(dynamic moduleAuthor) {
    final vip = moduleAuthor.vip;
    if (vip is Map) {
      return (vip['status'] ?? vip['vipStatus'] ?? 0) > 0;
    }
    return false;
  }

  void _openMember(dynamic moduleAuthor) {
    final heroTag = StringUtils.makeHeroTag(moduleAuthor.mid);
    Get.toNamed(
      '/member/mid=${moduleAuthor.mid}',
      arguments: {
        'mid': moduleAuthor.mid?.toString(),
        'face': moduleAuthor.face,
        'heroTag': heroTag,
      },
    );
  }

  void _showMore(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_outlined, size: 19),
              title: Text('分享动态', style: theme.textTheme.titleSmall),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Icon(Icons.link_rounded, size: 19),
              title: Text('复制链接', style: theme.textTheme.titleSmall),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarWithPendant extends StatelessWidget {
  const _AvatarWithPendant({required this.author});

  final dynamic author;

  @override
  Widget build(BuildContext context) {
    final heroTag = StringUtils.makeHeroTag(author.mid);
    final pendant = author.pendant is Map ? author.pendant['image'] : null;
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Hero(
            tag: heroTag,
            child: NetworkImgLayer(
              width: 40,
              height: 40,
              type: 'avatar',
              src: author.face,
            ),
          ),
          if (pendant != null && pendant.toString().isNotEmpty)
            Positioned.fill(
              child: Transform.scale(
                scale: 1.45,
                child: NetworkImgLayer(
                  width: 58,
                  height: 58,
                  type: 'pendant',
                  src: pendant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ModuleTag extends StatelessWidget {
  const _ModuleTag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(width: 1.25, color: theme.colorScheme.primary),
      ),
      child: Text(
        text,
        style: TextStyle(
          height: 1,
          fontSize: 12,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _DecoratedAuthorHeader extends StatelessWidget {
  const _DecoratedAuthorHeader({
    required this.authorHeader,
    required this.decorate,
    this.moreButton,
  });

  final Widget authorHeader;
  final dynamic decorate;
  final Widget? moreButton;

  @override
  Widget build(BuildContext context) {
    final fan = decorate.fan;
    Widget header = Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 4,
          right: 0,
          bottom: 4,
          child: NetworkImgLayer(
            width: 92,
            height: 32,
            type: 'emote',
            src: decorate.cardUrl,
          ),
        ),
        if (fan?.numStr?.isNotEmpty == true)
          Positioned(
            top: 0,
            bottom: 0,
            right: 36,
            child: Center(
              child: Text(
                fan.numStr.toString(),
                style: TextStyle(
                  height: 1,
                  fontSize: 11,
                  fontFamily: 'digital_id_num',
                  color: _parseColor(fan.color) ??
                      Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 90),
          child: authorHeader,
        ),
      ],
    );
    if (moreButton != null) {
      header = Row(children: [Expanded(child: header), moreButton!]);
    }
    return header;
  }

  Color? _parseColor(String? color) {
    if (color == null || !color.startsWith('#')) return null;
    final hex = color.substring(1);
    final value = int.tryParse(hex.length == 6 ? 'ff$hex' : hex, radix: 16);
    return value == null ? null : Color(value);
  }
}
