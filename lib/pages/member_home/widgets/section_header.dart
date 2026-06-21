import 'package:flutter/material.dart';

class MemberHomeSectionHeader extends StatelessWidget {
  const MemberHomeSectionHeader({
    super.key,
    required this.title,
    required this.count,
    required this.onMore,
    this.visible,
  });

  final String title;
  final int count;
  final bool? visible;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color subColor = colorScheme.outline;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 10),
        child: Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '$title '),
                    TextSpan(
                      text: count.toString(),
                      style: TextStyle(fontSize: 13, color: subColor),
                    ),
                    if (visible != null)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            visible! ? Icons.visibility : Icons.visibility_off,
                            size: 17,
                            color: subColor,
                          ),
                        ),
                      ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: onMore,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                foregroundColor: subColor,
              ),
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.chevron_right, size: 18),
              label: const Text('更多'),
            ),
          ],
        ),
      ),
    );
  }
}
