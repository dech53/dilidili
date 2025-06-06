import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/http/dynamics.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/pages/moments/controller.dart';
import 'package:dilidili/pages/moments/widgets/rich_node_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ActionPanel extends StatefulWidget {
  const ActionPanel({super.key, required this.item});
  final DynamicItemModel item;
  @override
  State<ActionPanel> createState() => _ActionPanelState();
}

class _ActionPanelState extends State<ActionPanel>
    with TickerProviderStateMixin {
  final MomentsController _momentsController = Get.put(MomentsController());
  double defaultHeight = 260;
  late ModuleStatModel stat;
  RxBool isExpand = false.obs;
  RxDouble height = 260.0.obs;
  TextEditingController _inputController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  String _inputText = '';
  @override
  void initState() {
    super.initState();
    stat = widget.item.modules!.moduleStat!;
  }

  Widget dynamicPreview() {
    ItemModulesModel? modules = widget.item.modules;
    final String type = widget.item.type!;
    String? cover = modules?.moduleAuthor?.face;
    switch (type) {
      case 'DYNAMIC_TYPE_DRAW':
        cover = modules?.moduleDynamic?.major?.draw?.items?.first.src;
      case 'DYNAMIC_TYPE_AV':
        cover = modules?.moduleDynamic?.major?.archive?.cover;
      case 'DYNAMIC_TYPE_FORWARD':
        String forwardType = widget.item.orig!.type!;
        switch (forwardType) {
          case 'DYNAMIC_TYPE_DRAW':
            cover = modules?.moduleDynamic?.major?.draw?.items?.first.src;
          case 'DYNAMIC_TYPE_AV':
            cover = modules?.moduleDynamic?.major?.archive?.cover;
          case 'DYNAMIC_TYPE_ARTICLE':
            cover = '';
          case 'DYNAMIC_TYPE_PGC':
            cover = '';
          case 'DYNAMIC_TYPE_WORD':
            cover = '';
          case 'DYNAMIC_TYPE_LIVE_RCMD':
            cover = '';
          case 'DYNAMIC_TYPE_UGC_SEASON':
            cover = '';
          case 'DYNAMIC_TYPE_PGC_UNION':
            cover = modules?.moduleDynamic?.major?.pgc?.cover;
          default:
            cover = '';
        }
      case 'DYNAMIC_TYPE_ARTICLE':
        cover = '';
      case 'DYNAMIC_TYPE_PGC':
        cover = '';
      case 'DYNAMIC_TYPE_WORD':
        cover = '';
      case 'DYNAMIC_TYPE_LIVE_RCMD':
        cover = '';
      case 'DYNAMIC_TYPE_UGC_SEASON':
        cover = '';
      case 'DYNAMIC_TYPE_PGC_UNION':
        cover = '';
      default:
        cover = '';
    }
    return Container(
      width: double.infinity,
      height: 95,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 14),
      decoration: BoxDecoration(
        color:
            // ignore: deprecated_member_use
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(6),
        border: Border(
          left: BorderSide(
              width: 4,
              // ignore: deprecated_member_use
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '@${widget.item.modules!.moduleAuthor!.name}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2.r),
                  child: NetworkImgLayer(
                    src: cover ?? '',
                    width: 34,
                    height: 34,
                    type: 'emote',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    style: TextStyle(height: 0, fontSize: 12.sp),
                    richNode(widget.item, context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Text(data)
              ],
            ),
          ],
        ),
      ),
    );
  }

  togglePanelState(status, type) {
    if (!status) {
      Get.back();
      height.value = defaultHeight;
      _inputText = '';
      _inputController.clear();
    } else {
      height.value = Get.size.height;
    }
    if (type != 'fast_forward') isExpand.value = !(isExpand.value);
  }

  momentForward(String type) async {
    String dynamicId = widget.item.idStr!;
    var res = await DynamicsHttp.dynamicCreate(
      dynIdStr: dynamicId,
      mid: _momentsController.userInfo.mid,
      rawText: _inputText,
      scene: 4,
    );
    if (res['status']) {
      SmartDialog.showToast(type == 'forward' ? '转发成功' : '发布成功');
      togglePanelState(false, type);
    }
  }

  // 动态转发
  void forwardHandler() async {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) {
        return Obx(
          () => AnimatedContainer(
            duration: Durations.medium1,
            onEnd: () async {
              if (isExpand.value) {
                await Future.delayed(const Duration(milliseconds: 80));
                myFocusNode.requestFocus();
              }
            },
            height: height.value + MediaQuery.of(context).padding.bottom,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: Durations.medium1,
                  height: isExpand.value ? 34 : 0,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    isExpand.value ? 10 : 16,
                    10,
                    isExpand.value ? 14 : 12,
                    0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isExpand.value) ...[
                        IconButton(
                          onPressed: () => togglePanelState(false, ''),
                          icon: const Icon(Icons.close),
                        ),
                        Text(
                          '转发动态',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      ] else ...[
                        const Text(
                          '转发动态',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                      isExpand.value
                          ? FilledButton(
                              onPressed: () => momentForward('forward'),
                              child: const Text('转发'),
                            )
                          : TextButton(
                              onPressed: () => momentForward('fast_forward'),
                              child: const Text('立即转发'),
                            )
                    ],
                  ),
                ),
                if (!isExpand.value) ...[
                  GestureDetector(
                    onTap: () => togglePanelState(true, ''),
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.fromLTRB(16, 0, 10, 14),
                      child: Text(
                        '说点什么吧',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: TextField(
                      maxLines: 5,
                      focusNode: myFocusNode,
                      controller: _inputController,
                      onChanged: (value) {
                        setState(() {
                          _inputText = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '说点什么吧',
                      ),
                    ),
                  ),
                ],
                dynamicPreview(),
                if (!isExpand.value) ...[
                  const Divider(thickness: 0.1, height: 1),
                  ListTile(
                    onTap: () => Get.back(),
                    minLeadingWidth: 0,
                    dense: true,
                    title: Text(
                      '取消',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  Future onLikeDynamic() async {
    var item = widget.item!;
    String dynamicId = item.idStr!;
    Like like = item.modules!.moduleStat!.like!;
    int count = like.count == '点赞' ? 0 : int.parse(like.count ?? '0');
    bool status = like.status!;
    int up = status ? 2 : 1;
    var res = await DynamicsHttp.likeDynamic(dynamicId: dynamicId, up: up);
    if (res['status']) {
      SmartDialog.showToast(!status ? '点赞成功' : '取消赞');
      if (up == 1) {
        item.modules!.moduleStat!.like!.count = (count + 1).toString();
        item.modules!.moduleStat!.like!.status = true;
      } else {
        if (count == 1) {
          item.modules!.moduleStat!.like!.count = '点赞';
        } else {
          item.modules!.moduleStat!.like!.count = (count - 1).toString();
        }
        item.modules!.moduleStat!.like!.status = false;
      }
      setState(() {});
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).colorScheme.outline;
    var primary = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 1,
          child: TextButton.icon(
            onPressed: forwardHandler,
            icon: const Icon(
              FontAwesomeIcons.shareFromSquare,
              size: 16,
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              foregroundColor: Theme.of(context).colorScheme.outline,
            ),
            label: Text('转发'),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              FontAwesomeIcons.comment,
              size: 16,
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              foregroundColor: Theme.of(context).colorScheme.outline,
            ),
            label: Text(stat.comment!.count ?? '评论'),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextButton.icon(
            onPressed: () {
              onLikeDynamic();
            },
            icon: Icon(
              stat.like!.status!
                  ? FontAwesomeIcons.solidThumbsUp
                  : FontAwesomeIcons.thumbsUp,
              size: 16,
              color: stat.like!.status! ? primary : color,
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              foregroundColor: Theme.of(context).colorScheme.outline,
            ),
            label: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                stat.like!.count ?? '点赞',
                key: ValueKey<String>(stat.like!.count ?? '点赞'),
                style: TextStyle(
                  color: stat.like!.status! ? primary : color,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
