import 'package:dilidili/model/rcmd_video.dart';
import 'package:flutter/material.dart';

class VideoPage extends StatelessWidget {
  final VideoItem video;
  const VideoPage({super.key, required this.video});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _getVideoUI(video),
    );
  }

  Widget _getVideoUI(VideoItem video) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Text(video.title)
        ],
      ),
    );
  }
}
