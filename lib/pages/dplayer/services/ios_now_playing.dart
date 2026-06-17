import 'dart:io';

import 'package:dilidili/pages/dplayer/models/play_status.dart';
import 'package:flutter/services.dart';

class IosNowPlayingMetadata {
  const IosNowPlayingMetadata({
    required this.id,
    required this.title,
    this.artist,
    this.artworkUrl,
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.status = DPlayerStatus.paused,
    this.playbackRate = 1.0,
  });

  final String id;
  final String title;
  final String? artist;
  final String? artworkUrl;
  final Duration duration;
  final Duration position;
  final DPlayerStatus status;
  final double playbackRate;

  bool get isPlaying => status == DPlayerStatus.playing;

  IosNowPlayingMetadata copyWith({
    String? id,
    String? title,
    String? artist,
    String? artworkUrl,
    Duration? duration,
    Duration? position,
    DPlayerStatus? status,
    double? playbackRate,
  }) {
    return IosNowPlayingMetadata(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      artworkUrl: artworkUrl ?? this.artworkUrl,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      status: status ?? this.status,
      playbackRate: playbackRate ?? this.playbackRate,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'title': title,
      'artist': artist,
      'artworkUrl': artworkUrl,
      'duration': duration.inMilliseconds / 1000,
      'position': position.inMilliseconds / 1000,
      'isPlaying': isPlaying,
      'playbackRate': isPlaying ? playbackRate : 0,
    };
  }
}

class IosNowPlayingCommandHandler {
  const IosNowPlayingCommandHandler({
    this.onPlay,
    this.onPause,
    this.onTogglePlayPause,
    this.onSeek,
    this.onSkip,
  });

  final Future<void> Function()? onPlay;
  final Future<void> Function()? onPause;
  final Future<void> Function()? onTogglePlayPause;
  final Future<void> Function(Duration position)? onSeek;
  final Future<void> Function(Duration offset)? onSkip;
}

class IosNowPlayingService {
  IosNowPlayingService._() {
    if (Platform.isIOS) {
      _channel.setMethodCallHandler(_handleMethodCall);
    }
  }

  static final IosNowPlayingService instance = IosNowPlayingService._();
  static const MethodChannel _channel = MethodChannel('app.now_playing');

  IosNowPlayingCommandHandler? _commandHandler;

  void setCommandHandler(IosNowPlayingCommandHandler handler) {
    if (!Platform.isIOS) {
      return;
    }
    _commandHandler = handler;
  }

  Future<void> configure() async {
    if (!Platform.isIOS) {
      return;
    }
    await _invoke('configure');
  }

  Future<void> update(IosNowPlayingMetadata metadata) async {
    if (!Platform.isIOS) {
      return;
    }
    await _invoke('update', metadata.toMap());
  }

  Future<void> updatePlayback({
    required Duration duration,
    required Duration position,
    required DPlayerStatus status,
    required double playbackRate,
  }) async {
    if (!Platform.isIOS) {
      return;
    }
    await _invoke('updatePlayback', <String, Object?>{
      'duration': duration.inMilliseconds / 1000,
      'position': position.inMilliseconds / 1000,
      'isPlaying': status == DPlayerStatus.playing,
      'playbackRate': status == DPlayerStatus.playing ? playbackRate : 0,
    });
  }

  Future<void> clear() async {
    if (!Platform.isIOS) {
      return;
    }
    await _invoke('clear');
  }

  Future<void> _invoke(String method, [Object? arguments]) async {
    try {
      await _channel.invokeMethod<void>(method, arguments);
    } catch (_) {
      // Now Playing is a platform affordance; playback should not fail if the
      // bridge is unavailable in debug, simulator, or non-iOS builds.
    }
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    final IosNowPlayingCommandHandler? handler = _commandHandler;
    if (handler == null) {
      return null;
    }
    switch (call.method) {
      case 'play':
        await handler.onPlay?.call();
        break;
      case 'pause':
        await handler.onPause?.call();
        break;
      case 'togglePlayPause':
        await handler.onTogglePlayPause?.call();
        break;
      case 'seekTo':
        final double seconds = _numberArg(call.arguments, 'position');
        await handler.onSeek?.call(
          Duration(milliseconds: (seconds * 1000).round()),
        );
        break;
      case 'skip':
        final double seconds = _numberArg(call.arguments, 'offset');
        await handler.onSkip?.call(
          Duration(milliseconds: (seconds * 1000).round()),
        );
        break;
    }
    return null;
  }

  double _numberArg(dynamic arguments, String key) {
    if (arguments is Map) {
      final dynamic value = arguments[key];
      if (value is num) {
        return value.toDouble();
      }
      return double.tryParse(value?.toString() ?? '') ?? 0;
    }
    return 0;
  }
}
