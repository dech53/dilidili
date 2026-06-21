import 'package:dilidili/pages/follow_type/followed/controller.dart';
import 'package:dilidili/pages/follow_type/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowedPage extends StatefulWidget {
  const FollowedPage({super.key});

  @override
  State<FollowedPage> createState() => _FollowedPageState();

  static void toFollowedPage({dynamic mid, String? name}) {
    final int? parsedMid = _safeToInt(mid);
    if (parsedMid == null) return;
    Get.toNamed(
      '/followed',
      arguments: {
        'mid': parsedMid,
        'name': name,
      },
    );
  }

  static int? _safeToInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}

class _FollowedPageState extends FollowTypePageState<FollowedPage> {
  late final FollowedController _controller;

  @override
  FollowedController get controller => _controller;

  @override
  void initState() {
    super.initState();
    final Object? mid = Get.arguments?['mid'] ?? Get.parameters['mid'];
    final String tag = mid?.toString() ?? DateTime.now().toIso8601String();
    _controller = Get.isRegistered<FollowedController>(tag: tag)
        ? Get.find<FollowedController>(tag: tag)
        : Get.put(FollowedController(), tag: tag);
  }

  @override
  PreferredSizeWidget get appBar => AppBar(
        title: Obx(
          () => Text(
            '我关注的${controller.total.value}人也关注了${controller.name.value ?? 'TA'}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}
