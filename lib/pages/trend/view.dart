import 'dart:io';
import 'package:dilidili/pages/trend/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TrendPage extends StatefulWidget {
  const TrendPage({super.key});

  @override
  State<TrendPage> createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final TrendController _rankController = Get.put(TrendController());
  List videoList = [];
  late Stream<bool> stream;

  @override
  void initState() {
    super.initState();
    stream = _rankController.searchBarStream.stream;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: Platform.isAndroid
            ? SystemUiOverlayStyle(
                statusBarIconBrightness:
                    Theme.of(context).brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark,
              )
            : Theme.of(context).brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          const CustomAppBar(),
          if (_rankController.tabs.length > 1) ...[
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: TabBar(
                controller: _rankController.tabController,
                tabs: [
                  for (var i in _rankController.tabs) Tab(text: i['label'])
                ],
                isScrollable: true,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onSurface.withValues(
                          alpha: 0.68,
                        ),
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                indicator: _GlassPillTabIndicator(
                  color: Theme.of(context).colorScheme.primary.withValues(
                        alpha: 0.32,
                      ),
                ),
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Colors.transparent,
                enableFeedback: true,
                splashBorderRadius: BorderRadius.circular(8),
                tabAlignment: TabAlignment.center,
                onTap: (value) {
                  if (_rankController.initialIndex.value == value) {
                    _rankController.tabsCtrList[value].animateToTop();
                  }
                  _rankController.initialIndex.value = value;
                },
              ),
            )
          ] else ...[
            const SizedBox(height: 6),
          ],
          Expanded(
            child: TabBarView(
              controller: _rankController.tabController,
              children: _rankController.tabsPageList,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassPillTabIndicator extends Decoration {
  const _GlassPillTabIndicator({required this.color});

  final Color color;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _GlassPillTabIndicatorPainter(color);
  }
}

class _GlassPillTabIndicatorPainter extends BoxPainter {
  _GlassPillTabIndicatorPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Size size = configuration.size ?? Size.zero;
    if (size.isEmpty) return;

    final double width = size.width + 18;
    const double height = 5;
    final double left = offset.dx + (size.width - width) / 2;
    final double top = offset.dy + size.height - 8;
    final RRect pill = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, width, height),
      const Radius.circular(height / 2),
    );

    final Paint fillPaint = Paint()..color = color;
    canvas.drawRRect(pill, fillPaint);
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const CustomAppBar({
    super.key,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final double top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top,
      color: Colors.transparent,
    );
  }
}
