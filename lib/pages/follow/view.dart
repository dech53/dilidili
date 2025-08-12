import 'package:dilidili/custom/button/action_button.dart';
import 'package:dilidili/pages/follow/controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({super.key});

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage>
    with SingleTickerProviderStateMixin {
  late String mid;
  late FollowController _followController;
  final ScrollController scrollController = ScrollController();
  late AnimationController _controller;
  RxBool selected = false.obs;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    mid = Get.arguments['mid']!;
    _followController = Get.put(FollowController(), tag: mid);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          _followController.isOwner.value
              ? '我的关注'
              : '${_followController.name}的关注',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/followSearch?mid=$mid'),
            icon: const Icon(Icons.search_outlined),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                onTap: () => Get.toNamed('/blackListPage'),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.block, size: 19),
                    SizedBox(width: 10),
                    Text('黑名单管理'),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Center(
        child: Row(
          children: [
            ActionButton(
              borderWidth: 0.0,
              bgColor: Theme.of(context).colorScheme.primary.withOpacity(0.25),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.star,
                      color: Theme.of(context).colorScheme.primary,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '123',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize:
                            Theme.of(context).textTheme.labelMedium?.fontSize,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
