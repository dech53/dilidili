import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/space/space_archive/item.dart';
import 'package:dilidili/utils/image_save.dart';
import 'package:dilidili/utils/route_push.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class PgcCardVMemberPgc extends StatelessWidget {
  const PgcCardVMemberPgc({
    super.key,
    required this.item,
  });

  final SpaceArchiveItem item;

  @override
  Widget build(BuildContext context) {
    void onLongPress() {
      if ((item.cover ?? '').isEmpty) return;
      imageSaveDialog(context, _PgcCoverItem(item), SmartDialog.dismiss);
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: StyleString.mdRadius),
      child: InkWell(
        borderRadius: StyleString.mdRadius,
        onTap: () => RoutePush.bangumiPush(
          int.tryParse(item.param ?? ''),
          null,
        ),
        onLongPress: onLongPress,
        onSecondaryTap: onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 0.75,
              child: LayoutBuilder(
                builder: (context, boxConstraints) {
                  return NetworkImgLayer(
                    src: item.cover,
                    width: boxConstraints.maxWidth,
                    height: boxConstraints.maxHeight,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 5, 0, 3),
              child: Text(
                item.title,
                textAlign: TextAlign.start,
                style: const TextStyle(letterSpacing: 0.3),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PgcCoverItem {
  _PgcCoverItem(SpaceArchiveItem item)
      : pic = item.cover ?? '',
        cover = item.cover ?? '',
        title = item.title;

  final String pic;
  final String cover;
  final String title;
}
