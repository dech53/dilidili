import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/skeleton/skeleton.dart';
import 'package:flutter/material.dart';

class FavCardSkeleton extends StatelessWidget {
  const FavCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeleton(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: StyleString.aspectRatio,
          child: LayoutBuilder(
            builder: (context, boxConstraints) {
              return Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    borderRadius:
                        BorderRadius.circular(StyleString.imgRadius.x)),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 5, 6, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 200,
                height: 13,
                margin: const EdgeInsets.only(bottom: 5),
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
              Container(
                width: 150,
                height: 13,
                margin: const EdgeInsets.only(bottom: 12),
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
