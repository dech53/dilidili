import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/model/space/space_archive/item.dart';
import 'package:dilidili/pages/member_pgc/controller.dart';
import 'package:dilidili/pages/member_pgc/widgets/pgc_card_v_member_pgc.dart';
import 'package:dilidili/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberBangumi extends StatefulWidget {
  const MemberBangumi({
    super.key,
    required this.heroTag,
    required this.mid,
  });

  final String? heroTag;
  final int mid;

  @override
  State<MemberBangumi> createState() => _MemberBangumiState();
}

class _MemberBangumiState extends State<MemberBangumi>
    with AutomaticKeepAliveClientMixin {
  late final MemberBangumiCtr _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final String tag = widget.heroTag ?? widget.mid.toString();
    _controller = Get.isRegistered<MemberBangumiCtr>(tag: tag)
        ? Get.find<MemberBangumiCtr>(tag: tag)
        : Get.put(
            MemberBangumiCtr(heroTag: widget.heroTag, mid: widget.mid),
            tag: tag,
          );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _controller.onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              left: StyleString.safeSpace,
              right: StyleString.safeSpace,
              top: StyleString.safeSpace,
              bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
            ),
            sliver: Obx(() => _buildBody(context)),
          ),
        ],
      ),
    );
  }

  SliverGridDelegateWithExtentAndRatio _gridDelegate(BuildContext context) {
    return SliverGridDelegateWithExtentAndRatio(
      mainAxisSpacing: StyleString.cardSpace,
      crossAxisSpacing: StyleString.cardSpace,
      maxCrossAxisExtent: Grid.smallCardWidth * 0.6,
      childAspectRatio: 0.75,
      mainAxisExtent: MediaQuery.textScalerOf(context).scale(52),
    );
  }

  Widget _buildBody(BuildContext context) {
    final List<SpaceArchiveItem> itemList = _controller.itemList;
    if (itemList.isNotEmpty) {
      return SliverGrid.builder(
        gridDelegate: _gridDelegate(context),
        itemBuilder: (context, index) {
          if (index == itemList.length - 1) {
            _controller.onLoadMore();
          }
          return PgcCardVMemberPgc(item: itemList[index]);
        },
        itemCount: itemList.length,
      );
    }

    if (_controller.isLoading.value) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 400,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_controller.errorMsg.value.isNotEmpty) {
      return HttpError(
        errMsg: _controller.errorMsg.value,
        fn: _controller.onReload,
      );
    }

    return HttpError(
      errMsg: '暂无追番',
      fn: _controller.onReload,
      btnText: '刷新',
    );
  }
}
