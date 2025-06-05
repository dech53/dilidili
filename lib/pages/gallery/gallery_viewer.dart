import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/utils/download.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
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
  });
  final List<T> sources;
  final int initIndex;
  final double maxScale;
  final double minScale;
  final ValueChanged<int>? onPageChanged;
  @override
  State<GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<GalleryViewer>
    with SingleTickerProviderStateMixin {
  PageController? _pageController;
  TransformationController? _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  int? currentIndex;
  late Animation<Decoration> _opacityAnimation;
  late Offset _doubleTapLocalPosition;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initIndex);
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        _transformationController!.value =
            _animation?.value ?? Matrix4.identity();
      });
    _opacityAnimation = DecorationTween(
      begin: const BoxDecoration(color: Color(0xFF000000)),
      end: const BoxDecoration(color: Color(0x00000000)),
    ).animate(_animationController);
    currentIndex = widget.initIndex;
    setStatusBar();
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
    _animationController.dispose();
    try {
      StatusBarControl.setHidden(false, animation: StatusBarAnimation.FADE);
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBoxTransition(
      decoration: _opacityAnimation,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: _onPageChanged,
            controller: _pageController,
            itemCount: widget.sources.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onDoubleTapDown: (TapDownDetails details) {
                  _doubleTapLocalPosition = details.localPosition;
                },
                onDoubleTap: () {},
                onLongPress: onLongPress,
                child: _itemBuilder(widget.sources, index),
              );
            },
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
                  colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  widget.sources.length > 1
                      ? Text(
                          "${currentIndex! + 1}/${widget.sources.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        )
                      : const Spacer(),
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 0,
                          onTap: () {
                            onShareImg(widget.sources[currentIndex!]);
                          },
                          child: const Text("分享图片"),
                        ),
                        PopupMenuItem(
                          value: 1,
                          onTap: () {
                            onCopyImg(widget.sources[currentIndex!].toString());
                          },
                          child: const Text("复制图片"),
                        ),
                        PopupMenuItem(
                          value: 2,
                          onTap: () {
                            DownloadUtils.downloadImg(
                                widget.sources[currentIndex!]);
                          },
                          child: const Text("保存图片"),
                        ),
                      ];
                    },
                    child: const Icon(Icons.more_horiz, color: Colors.white),
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Center(
        child: Hero(
          tag: sources[index],
          child: CachedNetworkImage(
            fadeInDuration: const Duration(milliseconds: 0),
            imageUrl: sources[index],
            fit: BoxFit.contain,
          ),
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
                  onShareImg(widget.sources[currentIndex!]);
                  Navigator.of(context).pop();
                },
                title: const Text('分享图片'),
              ),
              ListTile(
                onTap: () {
                  onCopyImg(widget.sources[currentIndex!].toString());
                  Navigator.of(context).pop();
                },
                title: const Text('复制图片'),
              ),
              ListTile(
                onTap: () {
                  DownloadUtils.downloadImg(widget.sources[currentIndex!]);
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
    SmartDialog.showLoading();
    var response = await Dio()
        .get(imgUrl, options: Options(responseType: ResponseType.bytes));
    final temp = await getTemporaryDirectory();
    SmartDialog.dismiss();
    String imgName =
        "plpl_pic_${DateTime.now().toString().split('-').join()}.jpg";
    var path = '${temp.path}/$imgName';
    File(path).writeAsBytesSync(response.data);
    Share.shareXFiles([XFile(path)], subject: imgUrl);
  }

  void onCopyImg(String imgUrl) {
    Clipboard.setData(
            ClipboardData(text: widget.sources[currentIndex!].toString()))
        .then((value) {
      SmartDialog.showToast('已复制到粘贴板');
    }).catchError((err) {
      SmartDialog.showNotify(
        msg: err.toString(),
        notifyType: NotifyType.error,
      );
    });
  }
}
