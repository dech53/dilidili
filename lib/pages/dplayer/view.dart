import 'package:dilidili/pages/dplayer/controller.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

class DPlayer extends StatefulWidget {
  const DPlayer({super.key, required this.controller});
  final DPlayerController controller;
  @override
  State<DPlayer> createState() => _DPlayerState();
}

class _DPlayerState extends State<DPlayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        Video(
          controls: NoVideoControls,
          controller: widget.controller.videoController!,
        ),
      ],
    );
  }
}
