import 'package:dilidili/pages/gallery/gallery_viewer.dart';
import 'package:dilidili/pages/gallery/hero_route.dart';
import 'package:flutter/material.dart';

void openGalleryPreview(
  BuildContext context, {
  required List sources,
  required int initIndex,
  List<Object>? heroTags,
}) {
  final List<String> imageSources = sources
      .where((source) => source != null && source.toString().isNotEmpty)
      .map((source) => source.toString())
      .toList();
  if (imageSources.isEmpty) return;

  final int safeIndex = initIndex.clamp(0, imageSources.length - 1);
  Navigator.of(context).push(
    HeroRoute<void>(
      builder: (BuildContext context) => GalleryViewer<String>(
        sources: imageSources,
        initIndex: safeIndex,
        heroTags: heroTags,
        onPageChanged: (int pageIndex) {},
      ),
    ),
  );
}
