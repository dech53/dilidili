import 'package:dilidili/pages/moments/widgets/pic_panel.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';

Widget articlePanel(item, context, {floor = 1}) {
  TextStyle authorStyle =
      TextStyle(color: Theme.of(context).colorScheme.primary);
  return Padding(
    padding: floor == 2
        ? EdgeInsets.zero
        : const EdgeInsets.only(left: 12, right: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (floor == 2) ...[
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Text(
                  '@${item.modules.moduleAuthor.name}',
                  style: authorStyle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                NumUtils.dateFormat(item.modules.moduleAuthor.pubTs),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: Theme.of(context).textTheme.labelSmall!.fontSize),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        picWidget(item, context, floor)
      ],
    ),
  );
}
