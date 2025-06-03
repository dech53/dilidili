import 'package:dilidili/model/dynamics/result.dart';
import 'package:flutter/material.dart';
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
  double defaultHeight = 260;
  late ModuleStatModel stat;
  RxDouble height = 0.0.obs;
  @override
  void initState() {
    super.initState();
    stat = widget.item.modules!.moduleStat!;
  }

  //TODO跳转逻辑
  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).colorScheme.outline;
    var primary = Theme.of(context).colorScheme.primary;
    height.value = defaultHeight;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 1,
          child: TextButton.icon(
            onPressed: () {},
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
            onPressed: () {},
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
