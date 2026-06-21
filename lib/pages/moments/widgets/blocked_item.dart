import 'package:dilidili/model/dynamics/result.dart';
import 'package:flutter/material.dart';

Widget blockedItem(
  BuildContext context, {
  required ThemeData theme,
  required ModuleBlocked blocked,
}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.fromLTRB(12, 2, 12, 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: theme.colorScheme.secondaryContainer.withOpacity(0.45),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(
          Icons.lock_outline_rounded,
          size: 18,
          color: theme.colorScheme.onSecondaryContainer,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            blocked.title ?? blocked.hintMessage ?? '该内容暂不可见',
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ),
      ],
    ),
  );
}
