import 'package:dilidili/common/widgets/no_data.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/model/download.dart';
import 'package:dilidili/pages/download/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DownloadController controller = DownloadController.to;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Obx(
          () => Text(
            controller.tasks.isEmpty
                ? '离线缓存'
                : '离线缓存 (${controller.tasks.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
      body: Obx(
        () => CustomScrollView(
          slivers: [
            if (controller.tasks.isEmpty)
              const NoData()
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final DownloadTask task = controller.tasks[index];
                    return _DownloadTaskTile(task: task);
                  },
                  childCount: controller.tasks.length,
                ),
              ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).padding.bottom + 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadTaskTile extends StatelessWidget {
  const _DownloadTaskTile({required this.task});

  final DownloadTask task;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String metaText = [
      if (task.videoCodecDescription != null) task.videoCodecDescription!,
      if (task.audioQualityDescription != null) task.audioQualityDescription!,
    ].join(' · ');
    final String? errorMessage =
        task.errorMessage != null && task.errorMessage!.isNotEmpty
            ? task.errorMessage
            : null;
    final String statusText = errorMessage ?? _statusText;
    final String percentText = '${(task.progress * 100).floor()}%';

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: colorScheme.errorContainer,
        child: Icon(
          Icons.delete_outline,
          color: colorScheme.onErrorContainer,
        ),
      ),
      confirmDismiss: (_) => _askDelete(context, task),
      onDismissed: (_) => DownloadController.to.removeTask(task.id),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _handleCardTap(task),
          onLongPress: () => _confirmDelete(context, task),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 136,
                  height: 76,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        task.cover != null && task.cover!.isNotEmpty
                            ? NetworkImgLayer(
                                width: 136,
                                height: 76,
                                src: task.cover,
                              )
                            : Container(
                                color: colorScheme.surfaceContainerHighest,
                                child: Icon(
                                  Icons.video_file_outlined,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                        PBadge(
                          text: task.qualityDescription,
                          right: 6,
                          top: 6,
                          type: 'gray',
                          size: 'small',
                          fs: 11,
                        ),
                        if (task.duration != null && task.duration! > 0)
                          PBadge(
                            text: _formatDuration(task.duration),
                            right: 6,
                            bottom: 6,
                            type: 'gray',
                            size: 'small',
                            fs: 11,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title ?? task.bvid,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        statusText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: errorMessage == null
                                  ? colorScheme.primary
                                  : colorScheme.error,
                            ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: task.progress,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 36,
                            child: Text(
                              percentText,
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                      if (metaText.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          metaText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colorScheme.outline,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get _statusText {
    switch (task.status) {
      case DownloadStatus.pending:
        return '等待下载';
      case DownloadStatus.downloading:
        return '正在缓存';
      case DownloadStatus.paused:
        return '已暂停';
      case DownloadStatus.completed:
        return '缓存完成';
      case DownloadStatus.failed:
        return '缓存失败';
    }
  }

  String _formatDuration(int? milliseconds) {
    if (milliseconds == null || milliseconds <= 0) {
      return '';
    }
    final Duration duration = Duration(milliseconds: milliseconds);
    final int hours = duration.inHours;
    final String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '${duration.inMinutes}:$seconds';
  }

  void _handleCardTap(DownloadTask task) {
    switch (task.status) {
      case DownloadStatus.completed:
        if (task.videoPath != null) {
          _openVerifyPlayer(task);
        }
        break;
      case DownloadStatus.downloading:
      case DownloadStatus.pending:
        DownloadController.to.pauseTask(task.id);
        break;
      case DownloadStatus.paused:
      case DownloadStatus.failed:
        DownloadController.to.resumeTask(task.id);
        break;
    }
  }

  Future<void> _openVerifyPlayer(DownloadTask task) async {
    await Get.toNamed(
      '/downloadVerify',
      arguments: {
        'title': task.title ?? task.bvid,
        'videoPath': task.videoPath,
        'audioPath': task.audioPath,
        'qualityDescription': task.qualityDescription,
        'quality': task.quality,
        'videoCodecDescription': task.videoCodecDescription,
        'videoCodec': task.videoCodec,
        'audioQualityDescription': task.audioQualityDescription,
        'audioQuality': task.audioQuality,
        'sourceType': task.sourceType,
        'duration': task.duration,
        'downloadedBytes': task.downloadedBytes,
        'totalBytes': task.totalBytes,
      },
    );
  }

  Future<bool> _askDelete(BuildContext context, DownloadTask task) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('删除缓存'),
          content: Text(
            task.status == DownloadStatus.completed
                ? '确认删除该缓存视频？本地文件会被删除。'
                : '确认删除该下载任务？已下载的缓存文件也会被删除。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                '删除',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );

    return confirmed == true;
  }

  Future<void> _confirmDelete(BuildContext context, DownloadTask task) async {
    final bool confirmed = await _askDelete(context, task);
    if (confirmed) {
      await DownloadController.to.removeTask(task.id);
    }
  }
}
