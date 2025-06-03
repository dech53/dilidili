import 'dart:async';

import 'package:dilidili/pages/moments/detail/controller.dart';
import 'package:dilidili/pages/moments/widgets/author_panel.dart';
import 'package:dilidili/pages/moments/widgets/dynamic_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MomentsDetail extends StatefulWidget {
  const MomentsDetail({super.key});

  @override
  State<MomentsDetail> createState() => _MomentsDetailState();
}

class _MomentsDetailState extends State<MomentsDetail>
    with TickerProviderStateMixin {
  late MomentsDetailController _momentsDetailController;
  late StreamController<bool> titleStreamC = StreamController<bool>.broadcast();
  late ScrollController scrollController;
  late AnimationController fabAnimationCtr; // 回复类型
  late int replyType;
  bool _visibleTitle = false;
  int oid = 0;

  @override
  void initState() {
    super.initState();
    Map args = Get.arguments;
    int floor = args['floor'];
    // 评论类型
    int commentType = args['item'].basic!['comment_type'] ?? 11;
    replyType = (commentType == 0) ? 11 : commentType;
    if (floor == 1) {
      oid = int.parse(args['item'].basic!['comment_id_str']);
    }
    _momentsDetailController =
        Get.put(MomentsDetailController(oid, replyType), tag: oid.toString());
    fabAnimationCtr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fabAnimationCtr.forward();
    scrollController = _momentsDetailController.scrollController;
    scrollController.addListener(() {
      if (scrollController.offset > 55 && !_visibleTitle) {
        _visibleTitle = true;
        titleStreamC.add(true);
      } else if (scrollController.offset <= 55 && _visibleTitle) {
        _visibleTitle = false;
        titleStreamC.add(false);
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    fabAnimationCtr.dispose();
    scrollController.dispose();
    titleStreamC.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleSpacing: 0,
        title: StreamBuilder(
          stream: titleStreamC.stream,
          initialData: false,
          builder: (context, AsyncSnapshot snapshot) {
            return AnimatedOpacity(
              opacity: snapshot.data ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: AuthorPanel(item: _momentsDetailController.item),
            );
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: DynamicPanel(
                item: _momentsDetailController.item,
                source: 'detail',
              ),
            )
          ],
        ),
      ),
    );
  }
}
