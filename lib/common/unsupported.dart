import 'package:flutter/material.dart';

class UnsupportedMemberTabPage extends StatelessWidget {
  const UnsupportedMemberTabPage({
    super.key,
    required this.title,
    this.param,
  });

  final String title;
  final String? param;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.construction_outlined,
                    size: 42,
                    color: colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$title暂未实现',
                    style: TextStyle(
                      fontSize: 15,
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (param?.isNotEmpty == true) ...[
                    const SizedBox(height: 6),
                    Text(
                      param!,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
