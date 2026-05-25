import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/pages/gallery/custom_dismissible.dart';
import 'package:dilidili/pages/gallery/interactive_viewer_boundary.dart';
import 'package:dilidili/utils/download.dart';
import 'package:dilidili/utils/method_channel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_bar_control/status_bar_control.dart';

class GalleryViewer<T> extends StatefulWidget {
  const GalleryViewer({
    super.key,
    required this.sources,
    required this.initIndex,
    this.maxScale = 4.5,
    this.minScale = 1.0,
    this.onPageChanged,
    this.heroTags,
  });
  final List<T> sources;
  final int initIndex;
  final double maxScale;
  final double minScale;
  final ValueChanged<int>? onPageChanged;
  final List<Object>? heroTags;
  @override
  State<GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<GalleryViewer>
    with SingleTickerProviderStateMixin {
  static const LiquidGlassSettings _controlGlassSettings = LiquidGlassSettings(
    thickness: 28,
    blur: 4,
    chromaticAberration: 0.25,
    lightIntensity: 0.55,
    refractiveIndex: 1.55,
    saturation: 0.75,
    ambientStrength: 1,
    glassColor: Color(0x33FFFFFF),
  );

  PageController? _pageController;
  TransformationController? _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  late int currentIndex;
  late Offset _doubleTapLocalPosition;

  /// `true` when an source is zoomed in and not at the at a horizontal boundary
  /// to disable the [PageView].
  bool _enablePageView = true;

  /// `true` when an source is zoomed in to disable the [CustomDismissible].
  bool _enableDismiss = true;

  @override
  void initState() {
    super.initState();
    currentIndex = _safeInitialIndex;
    _pageController = PageController(initialPage: currentIndex);
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        _transformationController!.value =
            _animation?.value ?? Matrix4.identity();
      });

    setStatusBar();
  }

  int get _safeInitialIndex {
    if (widget.sources.isEmpty) return 0;
    if (widget.initIndex < 0) return 0;
    if (widget.initIndex >= widget.sources.length) {
      return widget.sources.length - 1;
    }
    return widget.initIndex;
  }

  setStatusBar() async {
    if (Platform.isIOS || Platform.isAndroid) {
      await StatusBarControl.setHidden(true,
          animation: StatusBarAnimation.FADE);
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      currentIndex = page;
    });
    widget.onPageChanged?.call(page);
    if (_transformationController!.value != Matrix4.identity()) {
      _animation = Matrix4Tween(
        begin: _transformationController!.value,
        end: Matrix4.identity(),
      ).animate(
        CurveTween(curve: Curves.easeOut).animate(_animationController),
      );
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pageController!.dispose();
    _transformationController!.dispose();
    _animationController.dispose();
    try {
      StatusBarControl.setHidden(false, animation: StatusBarAnimation.FADE);
    } catch (_) {}
    super.dispose();
  }

  void _onScaleChanged(double scale) {
    final bool initialScale = scale <= widget.minScale;

    if (initialScale) {
      if (!_enableDismiss) {
        setState(() {
          _enableDismiss = true;
        });
      }

      if (!_enablePageView) {
        setState(() {
          _enablePageView = true;
        });
      }
    } else {
      if (_enableDismiss) {
        setState(() {
          _enableDismiss = false;
        });
      }

      if (_enablePageView) {
        setState(() {
          _enablePageView = false;
        });
      }
    }
  }

  void _onLeftBoundaryHit() {
    if (!_enablePageView && currentIndex > 0) {
      setState(() {
        _enablePageView = true;
      });
    }
  }

  void _onRightBoundaryHit() {
    if (!_enablePageView && currentIndex < widget.sources.length - 1) {
      setState(() {
        _enablePageView = true;
      });
    }
  }

  void _onNoBoundaryHit() {
    if (_enablePageView) {
      setState(() {
        _enablePageView = false;
      });
    }
  }

  onDoubleTap() {
    Matrix4 matrix = _transformationController!.value.clone();
    double currentScale = matrix.row0.x;

    double targetScale = widget.minScale;

    if (currentScale <= widget.minScale) {
      targetScale = widget.maxScale * 0.7;
    }

    double offSetX = targetScale == 1.0
        ? 0.0
        : -_doubleTapLocalPosition.dx * (targetScale - 1);
    double offSetY = targetScale == 1.0
        ? 0.0
        : -_doubleTapLocalPosition.dy * (targetScale - 1);

    matrix = Matrix4.fromList([
      targetScale,
      matrix.row1.x,
      matrix.row2.x,
      matrix.row3.x,
      matrix.row0.y,
      targetScale,
      matrix.row2.y,
      matrix.row3.y,
      matrix.row0.z,
      matrix.row1.z,
      targetScale,
      matrix.row3.z,
      offSetX,
      offSetY,
      matrix.row2.w,
      matrix.row3.w
    ]);

    _animation = Matrix4Tween(
      begin: _transformationController!.value,
      end: matrix,
    ).animate(
      CurveTween(curve: Curves.easeOut).animate(_animationController),
    );
    _animationController
        .forward(from: 0)
        .whenComplete(() => _onScaleChanged(targetScale));
  }

  void _runAfterGlassMenuClosed(VoidCallback action) {
    Future<void>.delayed(const Duration(milliseconds: 220), () {
      if (!mounted) return;
      action();
    });
  }

  Object _heroTagFor(int index) {
    final List<Object>? heroTags = widget.heroTags;
    if (heroTags != null && index >= 0 && index < heroTags.length) {
      return heroTags[index];
    }
    return widget.sources[index] as Object;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sources.isEmpty) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: Text(
            '暂无图片',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      );
    }

    return ColoredBox(
      color: Colors.black,
      child: Stack(
        children: [
          CustomDismissible(
            onDismissed: () {
              Navigator.of(context).pop();
              // widget.onDismissed?.call(_pageController!.page!.floor());
            },
            enabled: _enableDismiss,
            child: PageView.builder(
              physics: _enablePageView
                  ? const PageScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              onPageChanged: _onPageChanged,
              controller: _pageController,
              itemCount: widget.sources.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onDoubleTapDown: (TapDownDetails details) {
                    _doubleTapLocalPosition = details.localPosition;
                  },
                  onDoubleTap: onDoubleTap,
                  onLongPress: onLongPress,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: InteractiveViewerBoundary(
                    controller: _transformationController,
                    boundaryWidth: MediaQuery.of(context).size.width,
                    onScaleChanged: _onScaleChanged,
                    onLeftBoundaryHit: _onLeftBoundaryHit,
                    onRightBoundaryHit: _onRightBoundaryHit,
                    onNoBoundaryHit: _onNoBoundaryHit,
                    maxScale: widget.maxScale,
                    minScale: widget.minScale,
                    child: _itemBuilder(widget.sources, index),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  12, 8, 20, MediaQuery.of(context).padding.bottom + 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlassButton(
                    label: '关闭',
                    width: 44,
                    height: 44,
                    iconSize: 22,
                    iconColor: Colors.white,
                    settings: _controlGlassSettings,
                    useOwnLayer: true,
                    quality: GlassQuality.standard,
                    icon: const Icon(Icons.close_rounded),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  widget.sources.length > 1
                      ? _GalleryGlassPageIndicator(
                          text: "${currentIndex + 1}/${widget.sources.length}",
                          settings: _controlGlassSettings,
                        )
                      : const Spacer(),
                  GlassMenu(
                    menuWidth: 170,
                    menuBorderRadius: 18,
                    glassSettings: _controlGlassSettings,
                    quality: GlassQuality.standard,
                    triggerBuilder: (context, toggleMenu) => GlassButton(
                      label: '更多',
                      width: 44,
                      height: 44,
                      iconSize: 22,
                      iconColor: Colors.white,
                      settings: _controlGlassSettings,
                      useOwnLayer: true,
                      quality: GlassQuality.standard,
                      icon: const Icon(Icons.more_horiz_rounded),
                      onTap: toggleMenu,
                    ),
                    items: [
                      GlassMenuItem(
                        title: '分享图片',
                        icon: const Icon(Icons.ios_share_rounded),
                        onTap: () {
                          final String imgUrl =
                              widget.sources[currentIndex].toString();
                          _runAfterGlassMenuClosed(() => onShareImg(imgUrl));
                        },
                      ),
                      GlassMenuItem(
                        title: '复制图片',
                        icon: const Icon(Icons.copy_rounded),
                        onTap: () {
                          final String imgUrl =
                              widget.sources[currentIndex].toString();
                          _runAfterGlassMenuClosed(() => onCopyImg(imgUrl));
                        },
                      ),
                      GlassMenuItem(
                        title: '保存图片',
                        icon: const Icon(Icons.download_rounded),
                        onTap: () {
                          final String imgUrl =
                              widget.sources[currentIndex].toString();
                          _runAfterGlassMenuClosed(
                            () => DownloadUtils.downloadImg(imgUrl),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemBuilder(sources, index) {
    return Center(
      child: Hero(
        tag: _heroTagFor(index),
        child: CachedNetworkImage(
          fadeInDuration: const Duration(milliseconds: 120),
          fadeOutDuration: const Duration(milliseconds: 120),
          imageUrl: sources[index],
          fit: BoxFit.contain,
          progressIndicatorBuilder: (
            BuildContext context,
            String url,
            DownloadProgress progress,
          ) {
            return _buildLoading(progress.progress);
          },
          errorWidget: (BuildContext context, String url, Object error) {
            return const _GalleryImageError();
          },
        ),
      ),
    );
  }

  Widget _buildLoading(double? progress) {
    final bool hasProgress = progress != null && progress > 0;
    return Center(
      child: SizedBox(
        width: 56,
        height: 56,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: hasProgress ? progress : null,
              strokeWidth: 2.5,
              color: Colors.white,
              backgroundColor: Colors.white24,
            ),
            if (hasProgress)
              Text(
                '${(progress * 100).clamp(0, 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  decoration: TextDecoration.none,
                ),
              ),
          ],
        ),
      ),
    );
  }

  onLongPress() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Center(
                    child: Container(
                      width: 32,
                      height: 3,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.outline,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(3))),
                    ),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  onShareImg(widget.sources[currentIndex]);
                  Navigator.of(context).pop();
                },
                title: const Text('分享图片'),
              ),
              ListTile(
                onTap: () {
                  onCopyImg(widget.sources[currentIndex].toString());
                  Navigator.of(context).pop();
                },
                title: const Text('复制图片'),
              ),
              ListTile(
                onTap: () {
                  DownloadUtils.downloadImg(widget.sources[currentIndex]);
                  Navigator.of(context).pop();
                },
                title: const Text('保存图片'),
              ),
            ],
          ),
        );
      },
    );
  }

  void onShareImg(String imgUrl) async {
    SmartDialog.showLoading(msg: '加载中');
    Object? error;
    try {
      var response = await Dio()
          .get(imgUrl, options: Options(responseType: ResponseType.bytes));
      final temp = await getTemporaryDirectory();
      String imgName =
          "plpl_pic_${DateTime.now().toString().split('-').join()}.jpg";
      var path = '${temp.path}/$imgName';
      File(path).writeAsBytesSync(response.data);
      Share.shareXFiles([XFile(path)], subject: imgUrl);
    } catch (e) {
      error = e;
    } finally {
      SmartDialog.dismiss();
    }
    if (error != null) {
      SmartDialog.showNotify(
        msg: error.toString(),
        notifyType: NotifyType.error,
      );
    }
  }
}

class _GalleryGlassPageIndicator extends StatelessWidget {
  const _GalleryGlassPageIndicator({
    required this.text,
    required this.settings,
  });

  final String text;
  final LiquidGlassSettings settings;

  @override
  Widget build(BuildContext context) {
    const LiquidShape shape = LiquidRoundedSuperellipse(borderRadius: 20);

    return AdaptiveLiquidGlassLayer(
      settings: settings,
      quality: GlassQuality.standard,
      shape: shape,
      child: SizedBox(
        height: 36,
        child: AdaptiveGlass.grouped(
          quality: GlassQuality.standard,
          shape: shape,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GalleryImageError extends StatelessWidget {
  const _GalleryImageError();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.broken_image_outlined,
            color: Colors.white70,
            size: 36,
          ),
          SizedBox(height: 10),
          Text(
            '图片加载失败',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
