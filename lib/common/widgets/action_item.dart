import 'package:flutter/material.dart';

class ActionItem extends StatelessWidget {
  final dynamic icon;
  final Icon? selectIcon;
  final Function? onTap;
  final Function? onLongPress;
  final String? text;
  final bool selectStatus;

  const ActionItem({
    Key? key,
    this.icon,
    this.selectIcon,
    this.onTap,
    this.onLongPress,
    this.text,
    this.selectStatus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color bgColor = selectStatus
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onInverseSurface;
    final Color contentColor = selectStatus
        ? Theme.of(context).colorScheme.onInverseSurface
        : Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: () => {
        onTap!(),
      },
      onLongPress: () => {
        if (onLongPress != null)
          {
            onLongPress!(),
          }
      },
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon is Icon
                ? Icon(
                    selectStatus
                        ? (selectIcon?.icon ?? (icon as Icon).icon)
                        : (icon as Icon).icon,
                    color: contentColor,
                    size: 14,
                  )
                : Image.asset(
                    'assets/images/coin.png',
                    width: IconTheme.of(context).size,
                    color: contentColor,
                  ),
            const SizedBox(width: 6),
            Text(
              text ?? '',
              style: TextStyle(
                color: contentColor,
                fontSize: Theme.of(context).textTheme.labelMedium?.fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
