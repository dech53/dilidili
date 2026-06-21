import 'package:dilidili/common/skeleton/skeleton.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/common/widgets/no_data.dart';
import 'package:dilidili/model/follow/result.dart';
import 'package:dilidili/pages/follow_type/controller.dart';
import 'package:dilidili/pages/follow_type/widgets/item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class FollowTypePageState<T extends StatefulWidget> extends State<T> {
  FollowTypeController get controller;

  PreferredSizeWidget? get appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            Obx(() => _buildBody()),
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.viewPaddingOf(context).bottom + 60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    final List<FollowItemModel> itemList = controller.itemList;
    if (itemList.isNotEmpty) {
      return SliverList.builder(
        itemBuilder: (context, index) {
          if (index == itemList.length - 1) {
            controller.onLoadMore();
          }
          return buildItem(index, itemList[index]);
        },
        itemCount: itemList.length,
      );
    }

    if (controller.isLoading.value) {
      return SliverList.builder(
        itemBuilder: (context, index) => const _FollowTypeSkeleton(),
        itemCount: 12,
      );
    }

    if (controller.errorMsg.value.isNotEmpty) {
      return HttpError(
        errMsg: controller.errorMsg.value,
        fn: controller.onReload,
      );
    }

    return const NoData();
  }

  Widget buildItem(int index, FollowItemModel item) =>
      FollowTypeItem(item: item);
}

class _FollowTypeSkeleton extends StatelessWidget {
  const _FollowTypeSkeleton();

  @override
  Widget build(BuildContext context) {
    final Color color =
        Theme.of(context).colorScheme.onInverseSurface.withValues(alpha: 0.65);
    return Skeleton(
      child: SizedBox(
        height: 66,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 120, height: 14, color: color),
                    const SizedBox(height: 8),
                    Container(width: 220, height: 12, color: color),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
